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
import android.view.ContextThemeWrapper;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class NewGroup extends AppCompatActivity {

    //Will allow the new group activity to write information
    WriteAndRead write = new WriteAndRead();

    //Groups info array will hold all the groups the user has created
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();

    //Variables for the text fields
    EditText groupInfo;
    EditText groupName;

    //Holds the enter group name and information
    String name;
    String info;

    //Check box to include user information
    CheckBox userInfo;

    //Strings to hold empty santa information that will later be overwritten
    String userName;
    String userContact;
    String userInterests;
    String userContactType;

    //Will check if the group exists
    boolean groupExists = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_group);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //Setting group name and info fields
        groupName = (EditText) findViewById(R.id.newGroupName);
        groupInfo = (EditText) findViewById(R.id.newGroupInfo);

        //Reference for user info check box
        userInfo = (CheckBox) findViewById(R.id.includeUserInfo);

        //Shared preferences
        String name = "UserInfo";

        SharedPreferences userInfo = getSharedPreferences(name, 0);
        userName = userInfo.getString("UserName", "");
        userContact = userInfo.getString("UserContactInfo", "");
        userInterests = userInfo.getString("UserInterests", "");
        userContactType = userInfo.getString("UserContactType", "");

        //Read the file to set groupsinfo
        if (fileExists("groups.data")){
            try {
                readFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
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
                saveGroup();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    //Saveing the group will display a dialog making sure that the user want to add the group and toast notifications if information is missing or the group exists
    public void saveGroup() throws IOException {
            String title;
            String message;

            final AlertDialog alert = new AlertDialog.Builder(
                    new ContextThemeWrapper(this,android.R.style.TextAppearance_Theme))
                    .create();

            if (groupName.getText().toString().equals("")){
                Toast.makeText(getApplicationContext(), "Group Name Missing",
                        Toast.LENGTH_LONG).show();
            } else {
                if (groupsInfo != null) {
                    for (int i = 0; i < groupsInfo.size(); i++) {
                        String groupNames = groupsInfo.get(i).getmGName();
                        String inputNames = groupName.getText().toString();

                        if (groupNames.toUpperCase().equals(inputNames.toUpperCase())) {
                            groupExists = true;
                        }
                    }
                }

                if (groupExists){
                    Toast.makeText(getApplicationContext(), "Group already exists",
                            Toast.LENGTH_LONG).show();
                } else {
                    if (groupInfo.getText().toString().equals("")){
                        title = "Save Group";
                        message = "Are you sure you want to save changes without any additional information?";
                    } else {
                        title = "Save Group";
                        message = "Are you sure you want to save group?";
                    }

                    alert.setTitle(title);
                    alert.setMessage(message);
                    alert.setCancelable(true);
                    alert.setCanceledOnTouchOutside(false);

                    alert.setButton(DialogInterface.BUTTON_POSITIVE, "Save",
                            new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    if (groupName.getText().toString().equals("")) {
                                    } else {
                                        name = groupName.getText().toString();
                                    }
                                    if (groupInfo.getText().toString().equals("")) {
                                        info = "";
                                    } else {
                                        info = groupInfo.getText().toString();
                                    }
                                    ArrayList<SantaInfo> santaInfo = new ArrayList<>();

                                    if (userInfo.isChecked()) {
                                        santaInfo.add(new SantaInfo(userName, userContact, userInterests, userContactType));
                                    }
                                    groupsInfo.add(new GroupsInfo(name, info, santaInfo));
                                    try {
                                        saveFile(groupsInfo);
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
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
                                }
                            });

                    alert.show();
                }
                groupExists = false;
            }


    }

    public void exitAddView() throws IOException {
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, MainActivity.class);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        saveFile(groupsInfo);
        setResult(RESULT_OK, returnIntent);
        finish();
    }

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
    //Calls read file method in the read and write class
    public ArrayList<GroupsInfo> readFile() throws IOException {
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = write.readFile(fin);
        return groupsInfo;
    }


}
