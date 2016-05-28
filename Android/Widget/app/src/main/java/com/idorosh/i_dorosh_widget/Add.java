/**
 * Created by Ian Dorosh on 11/12/15.
 * MDF 3 1511
 * Week 3 Widget
 */

package com.idorosh.i_dorosh_widget;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.Toast;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class Add extends Activity {

    //Holds the array list that is received from the phone.data file
    ArrayList<Info> itemsInfo = new ArrayList<>();

    //Read and write class reference
    ReadAndWrite write = new ReadAndWrite();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add);
        //Reading the stored file
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_add, menu);
        return true;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        //Save button in the action bar will run savephone method
        if (id == R.id.action_settings) {
            savePhone();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onPause() {
        super.onPause();
        //Will exit app when the home button is clicked if the widget called this class
        String caller = (getIntent().getStringExtra("add"));
        if (caller != null){
            System.exit(0);
        }

    }

    private void savePhone(){

        //Text fields in add view.
        final EditText item1Text = (EditText) findViewById(R.id.newPhoneName);
        final EditText item2Text = (EditText) findViewById(R.id.newPhoneOS);
        final EditText item3Text = (EditText) findViewById(R.id.newPhoneCarrier);
        final EditText item4Text = (EditText) findViewById(R.id.newPhonePrice);

        //Alert diolog to verify that the user wished to add the new information.
        new AlertDialog.Builder(this)
                .setTitle("Add Posting")
                .setMessage("Would you like to add the "+item1Text.getText().toString())
                .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {

                        //Adding new info into arraylist
                        itemsInfo.add(new Info(item1Text.getText().toString(), item2Text.getText().toString(), item3Text.getText().toString(), item4Text.getText().toString()));
                        Toast.makeText(getBaseContext(), item1Text.getText().toString()+" added", Toast.LENGTH_SHORT).show();

                        //Runs Add phone Method
                        try {
                            addPhone();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                })
                .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        // do nothing
                    }
                })
                .show();
    }

    //Add phone will start a returnIntent and also refresh the widget with new information
    private void addPhone() throws IOException {
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, MainActivity.class);
        returnIntent.putExtra("itemsInfo", itemsInfo);
        saveFile(itemsInfo);

        int widgetIDs[] = AppWidgetManager.getInstance(getApplication()).getAppWidgetIds(new ComponentName(getApplication(), WidgetProvider.class));
        for (int id : widgetIDs) {
            AppWidgetManager.getInstance(getApplication()).notifyAppWidgetViewDataChanged(id, R.id.phone_list);
        }

        //Exit activity
        setResult(RESULT_OK, returnIntent);
        finish();

        //Exits App if the widget called the activity
        String caller = (getIntent().getStringExtra("add"));
        if (caller != null){
            System.exit(0);
        }
    }

    //Calls create file method in the read and write class
    public String saveFile(ArrayList info) throws IOException {

        FileOutputStream fos = openFileOutput("phone.data", MODE_PRIVATE);

        write.createFile(fos, info);

        return null;
    }

    //Calls read file method in the read and write class
    public ArrayList<Info> readFile() throws IOException {
        FileInputStream fin = openFileInput("phone.data");
        itemsInfo = write.readFile(fin);
        return itemsInfo;
    }
}
