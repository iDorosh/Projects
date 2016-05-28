package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.ContextThemeWrapper;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class SantaView extends AppCompatActivity {

    //Array lists for the stored information
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();
    ArrayList<SantaInfo> santaInfo = new ArrayList<>();

    //current group index
    int currentIndex;

    //Add request
    public static final int addRequest = 1;

    //Adapter for the list view
    ArrayAdapter adapter;

    //Boolean to update the display when information is edited
    Boolean update = false;

    //For writing to storage
    WriteAndRead write = new WriteAndRead();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_santa_view);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //setting current group index
        currentIndex = getIntent().getExtras().getInt("Index");

        //Reading file
        try {
                readFile();
            } catch (IOException e) {
                e.printStackTrace();
            }


        //Setting santainfo of the current group
        santaInfo = groupsInfo.get(currentIndex).getmSantas();

        //Displays and empty label
        showEmptyLabel();

        //Populating ui
        updateDisplay();

        //Add button in the bottom right corner
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openAdd();
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_send, menu);
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
            if (santaInfo.size() <= 2){
                Toast.makeText(getApplicationContext(), "Please add at least 3 Santas",
                        Toast.LENGTH_LONG).show();
            } else {
                openSend();
            }
            return true;
        }
        if (id == R.id.action_deleteGroup) {
            showConfirmationAlert("Delete Group", "Would you like to remove this group from the list?", "Remove", "Cancel");
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    //Return intent when the back button is pressed
    public void onBackPressed() {
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, MainActivity.class);
        returnIntent.putExtra("current", currentIndex);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        setResult(RESULT_OK, returnIntent);
        super.onBackPressed();
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //Adding a santa
        if (resultCode == RESULT_OK && requestCode == addRequest) {
            groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
            santaInfo = groupsInfo.get(currentIndex).getmSantas();
            adapter.add(santaInfo);
            showEmptyLabel();

        }
        //deleting santa
        if (resultCode == RESULT_OK && requestCode == 0) {
            groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
            if (data.getExtras().getBoolean("delete")){
                int test;
                test = data.getExtras().getInt("current");
                adapter.remove(adapter.getItem(test));
                showEmptyLabel();
            } else {
                groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
                santaInfo = groupsInfo.get(currentIndex).getmSantas();
                update = true;
                adapter.notifyDataSetChanged();
                showEmptyLabel();
            }
        }
        //deleting group
        if (resultCode == RESULT_OK && requestCode == 2) {
            showEmptyLabel();
            deleteGroup();
            this.finish();
        }
    }

    //Will show an empty label
    public void showEmptyLabel(){
        TextView emptySanta = (TextView) findViewById(R.id.emptySanta);
        if (santaInfo.size() == 0){
            emptySanta.setVisibility(View.VISIBLE);
        } else {
            emptySanta.setVisibility(View.INVISIBLE);
        }
    }

    //Will populate the list view rows
    protected void updateDisplay() {
        //Gets list view
        ListView listView = (ListView) findViewById(R.id.listView2);
        adapter = new ArrayAdapter<SantaInfo>(this, R.layout.custom_santa_listview, R.id.santaName, santaInfo) {

            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                View view = super.getView(position, convertView, parent);

                //Getting text views from the xml files
                TextView text1 = (TextView) view.findViewById(R.id.santaName);
                TextView text2 = (TextView) view.findViewById(R.id.contactInfo);

                TextView text3 = (TextView) view.findViewById(R.id.santaInterests);

                text1.setText(santaInfo.get(position).getmSantaName());
                text2.setText(santaInfo.get(position).getmContact());

                if (santaInfo.get(position).getmInterests().equals("")){
                    text3.setText("Interests not added");
                } else {
                    text3.setText(santaInfo.get(position).getmInterests());
                }
                update = false;
                return view;
            }
        };

        //Setting adapter
        listView.setAdapter(adapter);

        //Runs when row is selected
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                openView(position);
            }
        });

    }

    //Dialog for various functions depending on the parameters
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
                        groupsInfo.remove(currentIndex);
                        try {
                            saveFile(groupsInfo);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                        deleteGroup();
                    }
                });

        alert.setButton(DialogInterface.BUTTON_NEGATIVE, cancel,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                    }
                });

        alert.show();
    }

    //Will open selected santa
    public void openView(int index){
        Intent intent = new Intent();
        intent.setClass(this, ViewSelectedSanta.class);
        intent.putExtra("santaIndex", index);
        intent.putExtra("groupIndex", currentIndex);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, 0);
    }

    //Open add screen
    public void openAdd(){
        Intent intent = new Intent();
        intent.setClass(this, Add.class);
        intent.putExtra("groupIndex", currentIndex);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, addRequest);
    }

    //Open send screen
    public void openSend(){
        Intent intent = new Intent();
        intent.setClass(SantaView.this, Send.class);
        intent.putExtra("groupIndex", currentIndex);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, 2);
    }

    //return intent to delete the group
    private void deleteGroup(){
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, MainActivity.class);
        returnIntent.putExtra("current", currentIndex);
        returnIntent.putExtra("groupsInfo", groupsInfo);
        setResult(RESULT_OK, returnIntent);
        finish();
    }

    //Will save information to internal storage
    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("groups.data", MODE_PRIVATE);
        write.createFile(fos, info);
        return null;
    }

    //Will read information from internal storage
    public ArrayList<GroupsInfo> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = getData.readFile(fin);
        return groupsInfo;
    }

}
