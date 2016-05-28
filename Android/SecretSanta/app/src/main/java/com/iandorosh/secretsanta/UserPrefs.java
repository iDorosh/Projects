package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
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

public class UserPrefs extends AppCompatActivity {

    //text field references
    EditText userName;
    EditText userContactInfo;
    EditText userInterests;

    //Checkbox references
    CheckBox useNumber;
    CheckBox useEmail;

    //Contact type for the user
    String contactType;

    //Arraylsits for the group and santa
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();
    ArrayList<SantaInfo> santaInfo = new ArrayList<>();

    //writing to storage
    WriteAndRead write = new WriteAndRead();

    //name before change so the save will update all current groups
    String previousName;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_prefs);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);


        //References for text fields and checkboxes
        userName = (EditText) findViewById(R.id.userName);
        userContactInfo = (EditText) findViewById(R.id.userContact);
        userInterests = (EditText) findViewById(R.id.userInterests);

        useNumber = (CheckBox) findViewById(R.id.userNumberCheck);
        useNumber.setOnClickListener(boxChecked);
        useEmail = (CheckBox) findViewById(R.id.userEmailCheck);
        useEmail.setOnClickListener(boxChecked);

        //Populate ui
        updateDisplay();

        if (useNumber.isChecked()){
            userContactInfo.setInputType(InputType.TYPE_CLASS_NUMBER);
            userContactInfo.setHint("123-123-1234");
            contactType = "Number";
        }
        if (useEmail.isChecked()){
            userContactInfo.setHint("alexJohnson@work.com");
            userContactInfo.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
            contactType = "Email";
        }

        //Reading file
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //Onlcick listener for checkboxes to determing contact type
    private View.OnClickListener boxChecked = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.userEmailCheck){
                if (!useEmail.isChecked()){
                    useEmail.setChecked(true);
                } else {
                    useNumber.setChecked(false);
                    userContactInfo.setHint("alexJohnson@work.com");
                    userContactInfo.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
                    userContactInfo.setText("");
                    contactType = "Email";
                }

            }
            if (v.getId() == R.id.userNumberCheck){
                if (!useNumber.isChecked()){
                    useNumber.setChecked(true);
                } else {
                    useEmail.setChecked(false);
                    userContactInfo.setInputType(InputType.TYPE_CLASS_NUMBER);
                    userContactInfo.setHint("123-123-1234");
                    userContactInfo.setText("");
                    contactType = "Number";
                }
            }
        }
    };

    @Override
    public void onBackPressed() {
        //Onback pressed will ask the user to add information if its first run otherwise it will just return back
        String prefName = "Prefs";
        SharedPreferences firstRun = getSharedPreferences(prefName, 0);
        if (firstRun.getBoolean("firstRun", true)) {
            Toast.makeText(getApplicationContext(), "Add user info to continue",
                    Toast.LENGTH_LONG).show();
        } else {
            finish();

        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_add_screen, menu);
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
                saveUserPrefs();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    //Populate display with shared preferences if its not first run
    public void updateDisplay(){
        String prefName = "Prefs";

        SharedPreferences firstRun = getSharedPreferences(prefName, 0);

        if (firstRun.getBoolean("firstRun", true)) {
        } else {

            String name = "UserInfo";

            SharedPreferences userInfo = getSharedPreferences(name, 0);
            userName.setText(userInfo.getString("UserName", ""));
            previousName = userInfo.getString("UserName", "");
            userContactInfo.setText(userInfo.getString("UserContactInfo", ""));
            userInterests.setText(userInfo.getString("UserInterests", ""));
            if (userInfo.getString("UserContactType", "").equals("Email")){
                useEmail.setChecked(true);
                useNumber.setChecked(false);

            }else {
                useEmail.setChecked(false);
                useNumber.setChecked(true);

            }
        }
    }

    //will save information to the shared preferences
    public void saveUserPrefs() throws IOException {

        String prefName = "Prefs";

        SharedPreferences firstRun = getSharedPreferences(prefName, 0);

        String name = "UserInfo";
        SharedPreferences userInfo = getSharedPreferences(name, 0);

        userInfo.edit().putString("UserName", userName.getText().toString()).commit();
        userInfo.edit().putString("UserContactInfo", userContactInfo.getText().toString()).commit();
        userInfo.edit().putString("UserInterests", userInterests.getText().toString()).commit();
        userInfo.edit().putString("UserContactType", contactType).commit();

        firstRun.edit().putBoolean("firstRun", false).commit();


        //Dialog will check for missing information and will update the current groups that the user has saved
        if (!firstRun.getBoolean("firstRun", true)) {
            if (userName.getText().toString().equals("") || userContactInfo.getText().toString().equals("")) {
                Toast.makeText(getApplicationContext(), "Name or Contact Empty",
                        Toast.LENGTH_LONG).show();
            } else {
                final AlertDialog alert = new AlertDialog.Builder(
                        new ContextThemeWrapper(this, android.R.style.TextAppearance_Theme))
                        .create();

                alert.setTitle(" Save User Information?");
                alert.setMessage("All current groups will also be updated with the new information");
                alert.setCancelable(true);
                alert.setCanceledOnTouchOutside(false);

                alert.setButton(DialogInterface.BUTTON_POSITIVE, "Save",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                try {
                                    updateGroups(userName.getText().toString(), userContactInfo.getText().toString(), userInterests.getText().toString(), contactType);
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }
                            }
                        });

                alert.setButton(DialogInterface.BUTTON_NEGATIVE, "Cancel",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                            }
                        });

                alert.show();
            }
        } else {
            //If not first run the checking for empty fields or displaying a toast for information saved
            if (userName.getText().toString().equals("") || userContactInfo.getText().toString().equals("")){
                Toast.makeText(getApplicationContext(), "Name or Contact Empty",
                        Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(getApplicationContext(), "My info saved",
                        Toast.LENGTH_LONG).show();
                exitAddView();
            }
        }

    }

    //Update groups will find all the santas with the same name as the user information name before edit and edit that information
    public void updateGroups(String userName, String userContactInfo, String userInterests, String userContactType) throws IOException {
        for (int i = 0; i < groupsInfo.size(); i++) {
                santaInfo = groupsInfo.get(i).getmSantas();
            for (int a = 0; a < santaInfo.size(); a++) {

                if (santaInfo.get(a).getmSantaName().equals(previousName)){
                    santaInfo.remove(a);
                    santaInfo.add(a, new SantaInfo(userName, userContactInfo, userInterests, userContactType));
                }
            }

        }
        exitAddView();
    }

    public void exitAddView() throws IOException {
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, MainActivity.class);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        saveFile(groupsInfo);
        setResult(RESULT_OK, returnIntent);
        finish();
    }

    //Calls create file method in the read and write class
    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("groups.data", MODE_PRIVATE);
        write.createFile(fos, info);
        return null;
    }

    //Will read file for the groups array list
    public ArrayList<GroupsInfo> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = getData.readFile(fin);
        return groupsInfo;
    }


}
