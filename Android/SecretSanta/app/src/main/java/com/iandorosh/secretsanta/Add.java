package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.InputType;
import android.view.ContextThemeWrapper;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class Add extends AppCompatActivity {

    //Current group will allow the user to add a santa to that group using an index
    int currentGroup;

    //Will allow the add screen to write new data to storage
    WriteAndRead write = new WriteAndRead();

    //Groups Info will hold all the information for the app and santaInfo will hold information of all the santas in current group
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();
    ArrayList<SantaInfo> santaInfo = new ArrayList<>();

    //Text fields and checkboxes for the add screen
    EditText addName;
    EditText addInfo;
    EditText addContact;
    CheckBox useNumber;
    CheckBox useEmail;

    //Contact type will be set depending on what check box the user selects
    String contactType;

    //Showspinner will be used to show the groups spinner on the add screen depending on what screen the user selects the santa
    Spinner showSpinner;

    //Will be used to check if santa exists
    boolean santaExists = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //Current index of the selected group
        currentGroup = getIntent().getExtras().getInt("groupIndex");

        //If the file exists then the information will be read
        if (fileExists("groups.data")){
            try {
                readFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        //References to show spinner
        showSpinner = (Spinner) findViewById(R.id.addSpinner);
        //Reference for the group label that will show with the spinner
        TextView groupLabel = (TextView) findViewById(R.id.selectGroupText);

        //Setting group label and spinner visibility
        if (getIntent().getExtras().getBoolean("showPicker")){
            showSpinner.setVisibility(View.VISIBLE);
            groupLabel.setVisibility(View.VISIBLE);
            populatePicker();
        }

        //Text field and checkbox references
        addName = (EditText) findViewById(R.id.addName);
        addInfo = (EditText) findViewById(R.id.addInterests);
        addContact = (EditText) findViewById(R.id.addContact);

        useNumber = (CheckBox) findViewById(R.id.addUseNumber);
        useNumber.setOnClickListener(boxChecked);
        useEmail = (CheckBox) findViewById(R.id.addUseEmail);
        useEmail.setOnClickListener(boxChecked);

        //Checking which checkbox is check
        if (useNumber.isChecked()){
            addContact.setInputType(InputType.TYPE_CLASS_NUMBER);
            addContact.setHint("123-123-1234");
            contactType = "Number";
        }
        if (useEmail.isChecked()){
            addContact.setHint("alexJohnson@work.com");
            addContact.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
            contactType = "Email";
        }

        //Getting the santainfo arraylist from the current group
        santaInfo = groupsInfo.get(currentGroup).getmSantas();

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_add_screen, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            try {
                addSanta();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    //Array adapter for the group spinner on the add screen
    public void populatePicker(){
        ArrayList<String> pickGroup = new ArrayList<>();
        for (int i = 0; i < groupsInfo.size(); i++) {
            pickGroup.add(groupsInfo.get(i).getmGName());
        }
        ArrayAdapter<String> stringArrayAdapter = new ArrayAdapter<>(this, R.layout.addspinner_layout, pickGroup);
        showSpinner.setAdapter(stringArrayAdapter);
        showSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                currentGroup = position;
                //Getting the santainfo arraylist from the current group
                santaInfo = groupsInfo.get(currentGroup).getmSantas();
            }
            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });
    }

    //Onclick listener to set the proper contacttype based on which checkbox the user clicks
    private View.OnClickListener boxChecked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.addUseEmail){
                if (!useEmail.isChecked()){
                    useEmail.setChecked(true);
                } else {
                    useNumber.setChecked(false);
                    addContact.setHint("alexJohnson@work.com");
                    addContact.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
                    contactType = "Email";
                }
            }
            if (v.getId() == R.id.addUseNumber){
                if (!useNumber.isChecked()){
                    useNumber.setChecked(true);
                } else {
                    useEmail.setChecked(false);
                    addContact.setInputType(InputType.TYPE_CLASS_NUMBER);
                    addContact.setHint("123-123-1234");
                    contactType = "Number";
                }
            }
        }
    };


    //Adding Santa dialog
    public void addSanta() throws IOException {


        //Will store the dialogs title and message;
            String name;
            String message;

        //Checking to see if the santa name or contact information is missing.
            if (addName.getText().toString().equals("") || addContact.getText().toString().equals("")){
                Toast.makeText(getApplicationContext(), "Name or Contact info Missing",
                        Toast.LENGTH_LONG).show();
            } else {


                //For loop to determine if the santa already exists
                for (int i = 0; i < santaInfo.size(); i++) {
                    String groupNames = santaInfo.get(i).getmSantaName();
                    String inputNames = addName.getText().toString();
                    if (groupNames.toUpperCase().equals(inputNames.toUpperCase())) {
                        santaExists = true;
                    }
                }

                    //Toast that will display if the santa name already exists
                    if (santaExists){
                        Toast.makeText(getApplicationContext(), "Santa already exists",
                                Toast.LENGTH_LONG).show();

                    } else {
                        //Will display a dialog if the user wants to save the secret santa without any interests
                        if (addInfo.getText().toString().equals("")) {
                            name = "Save Changes";
                            message = "Are you sure you want to save changes without any interests";
                        } else {
                            name = "Save Changes";
                            message = "Are you sure you want to save changes";
                        }


                        final AlertDialog alert = new AlertDialog.Builder(
                                new ContextThemeWrapper(this,android.R.style.TextAppearance_Theme))
                                .create();

                        alert.setTitle(name);
                        alert.setMessage(message);
                        alert.setCancelable(true);
                        alert.setCanceledOnTouchOutside(false);

                        alert.setButton(DialogInterface.BUTTON_POSITIVE, "Save",
                                new DialogInterface.OnClickListener() {
                                    public void onClick(DialogInterface dialog, int which) {

                                        //Adding the new santa to santaInfo
                                        santaInfo.add(new SantaInfo(addName.getText().toString(), addContact.getText().toString(), addInfo.getText().toString(), contactType));
                                        //Exit view will save the data and send information back to the santa view screen
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
                                        //Will simply close out the dialog
                                    }
                                });

                        //Will show the dialog
                        alert.show();
                    }
                    //setting the santaExists boolean back to false for the next time a user saves information
                    santaExists = false;


            }
    }

    //Will create a return intent with the new information and also save the new information to internal storage
    public void exitAddView() throws IOException {
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, SantaView.class);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        saveFile(groupsInfo);
        setResult(RESULT_OK, returnIntent);
        finish();
    }

    //Will check if the file exists before reading
    public boolean fileExists(String filename) {
        File file = this.getFileStreamPath(filename);
        if(file == null || !file.exists()) {
            return false;
        }
        return true;
    }

    //Calls create file method in the read and write class
    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("groups.data", MODE_PRIVATE);
        write.createFile(fos, info);
        return null;
    }

    //Calls read method in the read and write class
    public ArrayList<GroupsInfo> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = getData.readFile(fin);
        return groupsInfo;
    }
}
