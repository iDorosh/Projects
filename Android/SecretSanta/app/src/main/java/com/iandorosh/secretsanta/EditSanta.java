package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.InputType;
import android.view.ContextThemeWrapper;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class EditSanta extends AppCompatActivity {

    //Will contain the index for the current santa and for the current group
    int currentSanta;
    int currentGroup;

    //Array list for the information in internal storage
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();
    ArrayList<SantaInfo> santaInfo = new ArrayList<>();

    //Text Fields for Santa Information
    EditText editName;
    EditText editContactInfo;
    EditText editInterests;

    //Check boxes for contact type
    CheckBox useNumber;
    CheckBox useEmail;

    //String to hold contact type so it can be used to determine whether to send a text or email
    String contactType;

    //Check if the edited santa exists
    boolean santaExists = false;

    //Current name so if the user doesn't edit the name the app wont think that it already exists
    String currentName;

    //WriteandRead reference so the edit screen can read and write data
    WriteAndRead write = new WriteAndRead();



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_santa);

        //Setting current indexes
        currentGroup = getIntent().getExtras().getInt("groupIndex");
        currentSanta = getIntent().getExtras().getInt("santaIndex");

        //reading the current file
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Initializing the santainfo array
        santaInfo = groupsInfo.get(currentGroup).getmSantas();

        //Setting the current name before editing
        currentName = santaInfo.get(currentSanta).getmSantaName();

        //Will populate the ui
       updateDisplay();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_edit, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            try {
                editSanta();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return true;
        }

        return super.onOptionsItemSelected(item);
    }


    //Onlick listener for the checkboxes to determine what contact type will be used when sending the messages
    private View.OnClickListener boxChecked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.editEmailCheck){
                if (!useEmail.isChecked()){
                    useEmail.setChecked(true);
                } else {
                    useNumber.setChecked(false);
                    editContactInfo.setHint("alexJohnson@work.com");
                    editContactInfo.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
                    editContactInfo.setText("");
                    contactType = "Email";
                }

            }
            if (v.getId() == R.id.editNumberCheck){
                if (!useNumber.isChecked()){
                    useNumber.setChecked(true);
                } else {
                    useEmail.setChecked(false);
                    editContactInfo.setInputType(InputType.TYPE_CLASS_NUMBER);
                    editContactInfo.setHint("123-123-1234");
                    editContactInfo.setText("");
                    contactType = "Number";
                }
            }
        }
    };

    //Will change the information in the groupsinfo array list and will save the information
    public void editSanta() throws IOException {
        //Will store the message and title for the dialog
        String name;
        String message;

        final AlertDialog alert = new AlertDialog.Builder(
                new ContextThemeWrapper(this,android.R.style.TextAppearance_Theme))
                .create();

        //Will check if the required information is present
        if (editName.getText().toString().equals("") || editContactInfo.getText().toString().equals("")){
            Toast.makeText(getApplicationContext(), "Name or Contact info Missing",
                    Toast.LENGTH_LONG).show();
        } else {
            //Will check if the name already exists
            for (int i = 0; i < santaInfo.size(); i++) {

                String groupNames = santaInfo.get(i).getmSantaName();
                String inputNames = editName.getText().toString();
                if (groupNames.toUpperCase().equals(inputNames.toUpperCase())) {
                    santaExists = true;
                }
            }

                //Toast to say the name already exists
                if (santaExists && !editName.getText().toString().equals(currentName)) {
                    Toast.makeText(getApplicationContext(), "Santa already exists",
                            Toast.LENGTH_LONG).show();
                } else {

                    //Check to see if interests are empty
                    if (editInterests.getText().toString().equals("")) {
                        name = "Save Changes";
                        message = "Are you sure you want to save changes without any interests";
                    } else {
                        name = "Save Changes";
                        message = "Are you sure you want to save changes";
                    }

                    alert.setTitle(name);
                    alert.setMessage(message);
                    alert.setCancelable(true);
                    alert.setCanceledOnTouchOutside(false);

                    alert.setButton(DialogInterface.BUTTON_POSITIVE, "Save",
                            new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    //Updating the arraylists and saving to storage
                                    santaInfo.remove(currentSanta);
                                    santaInfo.add(currentSanta, new SantaInfo(editName.getText().toString(), editContactInfo.getText().toString(), editInterests.getText().toString(), contactType));

                                    try {
                                        exitAddView();
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                }
                            });

                    alert.setButton(DialogInterface.BUTTON_NEGATIVE, "Cancel",
                            new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    //Simple closes the alert dialog
                                }
                            });
                    alert.show();
                }

        }




    }


    //Will create a return intent and will save the information
    public void exitAddView() throws IOException {
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, ViewSelectedSanta.class);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        saveFile(groupsInfo);
        setResult(RESULT_OK, returnIntent);
        finish();
    }

    //Will populate the view by setting the checkboxes and text fields with the proper information from that santa
    public void updateDisplay(){
        useNumber = (CheckBox) findViewById(R.id.editNumberCheck);
        useNumber.setOnClickListener(boxChecked);
        useEmail = (CheckBox) findViewById(R.id.editEmailCheck);
        useEmail.setOnClickListener(boxChecked);

        editName = (EditText) findViewById(R.id.editText3);
        editContactInfo = (EditText) findViewById(R.id.editText4);
        editInterests = (EditText) findViewById(R.id.editText5);

        if (santaInfo.get(currentSanta).getmContactType().equals("Email")){
            useEmail.setChecked(true);
            useNumber.setChecked(false);

        }else {
            useEmail.setChecked(false);
            useNumber.setChecked(true);
        }

        if (useNumber.isChecked()){
            editContactInfo.setInputType(InputType.TYPE_CLASS_NUMBER);
            editContactInfo.setHint("123-123-1234");
            contactType = "Number";
        }
        if (useEmail.isChecked()){
            editContactInfo.setHint("alexJohnson@work.com");
            editContactInfo.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
            contactType = "Email";
        }

        editName.setText(santaInfo.get(currentSanta).getmSantaName());
        editContactInfo.setText(santaInfo.get(currentSanta).getmContact());
        editInterests.setText(santaInfo.get(currentSanta).getmInterests());
    }

    //Calls create file method in the read and write class
    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("groups.data", MODE_PRIVATE);
        write.createFile(fos, info);
        return null;
    }

    //Calls read file method in the read and write class
    public ArrayList<GroupsInfo> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = getData.readFile(fin);
        return groupsInfo;
    }

}

