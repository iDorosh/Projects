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
import android.view.ContextThemeWrapper;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class ViewSelectedSanta extends AppCompatActivity {

    //Indexes for current selection
    int currentSanta;
    int currentGroup;

    //Arraylists for information in internal storage
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();
    ArrayList<SantaInfo> santaInfo = new ArrayList<>();

    //Text views
    TextView currentSantaName;
    TextView currentSantaContact;
    TextView currentSantaInterests;

    //edit request
    public static final int editRequest = 1;

    //Will allow this activity to write to storage
    WriteAndRead write = new WriteAndRead();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_selected_santa);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //Get current group and current santa
        currentSanta = getIntent().getExtras().getInt("santaIndex");
        currentGroup = getIntent().getExtras().getInt("groupIndex");

        //Reading the file
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //setting santa infor
        santaInfo = groupsInfo.get(currentGroup).getmSantas();

        //text view references
        currentSantaName = (TextView) findViewById(R.id.santaName);
        currentSantaContact = (TextView) findViewById(R.id.santaContactInfo);
        currentSantaInterests = (TextView) findViewById(R.id.santaInterests);

        //Populate ui
        updateDisplay();



    }

    @Override
    public void onBackPressed() {
        //return intent when the back button is pressed
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, SantaView.class);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        setResult(RESULT_OK, returnIntent);
        super.onBackPressed();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_view, menu);
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
            openEdit();
            return true;
        }
        if (id == R.id.action_deleteSanta) {
            showConfirmationAlert("Delete Santa", "Would you like to delete " +currentSantaName.getText().toString()+ "?", "Remove", "Cancel");
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    //Update ui
    public void updateDisplay(){
        currentSantaName.setText(santaInfo.get(currentSanta).getmSantaName());
        currentSantaContact.setText(santaInfo.get(currentSanta).getmContact());
        if (santaInfo.get(currentSanta).getmInterests().equals("")){
            currentSantaInterests.setText("Interests not added");
        } else {
            currentSantaInterests.setText(santaInfo.get(currentSanta).getmInterests());
        }

    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //Setting the picInfo to the updated list from add fragment by reading the updated file
        if (resultCode == RESULT_OK && requestCode == editRequest) {
            groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
            santaInfo = groupsInfo.get(currentGroup).getmSantas();
            updateDisplay();
        }

    }


    //Open edit intent
    public void openEdit(){
        Intent intent = new Intent();
        intent.setClass(this, EditSanta.class);
        intent.putExtra("santaIndex", currentSanta);
        intent.putExtra("groupIndex", currentGroup);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, editRequest);
    }

    //Read file
    public ArrayList<GroupsInfo> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = getData.readFile(fin);
        return groupsInfo;
    }

    //Dialog for deletion confirmation
    public void showConfirmationAlert(final String title, String message, final String confirm, final String cancel){
        final AlertDialog alert = new AlertDialog.Builder(
                new ContextThemeWrapper(this,android.R.style.TextAppearance_Theme))
                .create();
        alert.setTitle(title);
        alert.setMessage(message);
        alert.setCancelable(false);
        alert.setCanceledOnTouchOutside(false);

        alert.setButton(DialogInterface.BUTTON_POSITIVE, confirm,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        santaInfo.remove(currentSanta);
                        try {
                            saveFile(groupsInfo);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        deleteSanta();
                    }
                });

        alert.setButton(DialogInterface.BUTTON_NEGATIVE, cancel,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {


                    }
                });

        alert.show();
    }

    //Calls create file method in the read and write class
    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("groups.data", MODE_PRIVATE);
        write.createFile(fos, info);
        return null;
    }

    //Delete santa intent
    private void deleteSanta(){
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, SantaView.class);
        returnIntent.putExtra("current", currentSanta);
        returnIntent.putExtra("delete", true);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        setResult(RESULT_OK, returnIntent);
        finish();
    }

}
