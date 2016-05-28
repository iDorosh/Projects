package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.view.View;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;


public class MainActivity extends AppCompatActivity {

    //Array lists to hold groups santas and all santas
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();
    ArrayList<SantaInfo> allSantas = new ArrayList<>();
    ArrayList<SantaInfo> santaInfo = new ArrayList<>();

    //Arraylist adapter for the list view
    ArrayAdapter adapter;
    ListView listView;
    //Spinner options
    String[] options = {"Groups","All Santas"};
    int group;
    int santa;
    //Check if current view is all or groups
    boolean currentView = false;

    //refernece so that main menu can read and write files
    WriteAndRead write = new WriteAndRead();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayShowTitleEnabled(false);

        //Writes file if it doesnt exist
        if (fileExists("groups.data")){
        } else {
            try {
                saveFile(groupsInfo);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        //Reads file
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Will display spinner
        spinner();

        //Will check if the app is running for the first time
        checkFirstRun();

        //Will show empty label if groups info is empty
        showEmptyLabel();

        //Populate view
        updateDisplay();

        //Add groups button in the bottom right of the screen
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (currentView) {
                        if (groupsInfo.size() == 0) {
                            Toast.makeText(getApplicationContext(), "Please add a group first",
                                    Toast.LENGTH_LONG).show();
                        } else {
                            openSantaAdd();
                        }
                } else {
                    openAdd();
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
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
            prefs();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    //If first run then the welcome screen will appear
    public void checkFirstRun(){
        String name = "Prefs";
        SharedPreferences firstRun = getSharedPreferences(name, 0);
        if (firstRun.getBoolean("firstRun", true)) {
            welcome();
        }
    }

    //Will display and populate spinner
    public void spinner(){
        Spinner spinner = (Spinner) findViewById(R.id.spinner_nav);
        ArrayAdapter<String> stringArrayAdapter = new ArrayAdapter<>(this, R.layout.spinner_layout, options);
        spinner.setAdapter(stringArrayAdapter);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                //will run different methods depending on what the spinner is set to
                if (position == 0) {
                    currentView = false;
                    updateDisplay();
                    showEmptyLabel();
                    getAllSantas();

                } else {
                    currentView = true;
                    updateDisplay();
                    showEmptyLabel();
                    getAllSantas();

                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });


    }

    //Will get all santas to display on the main screen when all is selected in the spinner
    public void getAllSantas(){
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        allSantas.clear();

        for (int i = 0; i < groupsInfo.size(); i++) {
            santaInfo = groupsInfo.get(i).getmSantas();
            for (int a = 0; a < santaInfo.size(); a++) {
                allSantas.add(santaInfo.get(a));
            }
        }
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //Runs when coming back from new group screen
        if (resultCode == RESULT_OK && requestCode == 1) {
            groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
            updateDisplay();
        }

        //Runs when coming back from santa view
        int test;
        if (resultCode == RESULT_OK && requestCode == 3) {
            test = data.getExtras().getInt("current");
            adapter.remove(adapter.getItem(test));
            updateDisplay();
            showEmptyLabel();
            getAllSantas();
        }
        //Runs when coming back from view selected santa
        if (resultCode == RESULT_OK && requestCode == 0) {
            groupsInfo = (ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo");
            if (data.getExtras().getBoolean("delete")){
                int test1;
                test1 = data.getExtras().getInt("current");
                adapter.remove(adapter.getItem(test1));
                getAllSantas();

            } else {
                groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
                santaInfo = groupsInfo.get(group).getmSantas();
                getAllSantas();
                adapter.notifyDataSetChanged();
            }

        }
        //Runs when returning from santa add screen
        if (resultCode == RESULT_OK && requestCode == 4) {
            groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
            santaInfo = groupsInfo.get(group).getmSantas();
            getAllSantas();

        }
        //Runs when returning from user preferences screen
        if (resultCode == RESULT_OK && requestCode == 6) {
            groupsInfo = ((ArrayList<GroupsInfo>) data.getSerializableExtra("groupsInfo"));
            getAllSantas();
        }

        //Will update display
        updateDisplay();
    }

    public void showEmptyLabel(){
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
        getAllSantas();
        TextView emptyGroup = (TextView) findViewById(R.id.emptyGroup);
        if (currentView){
            emptyGroup.setText("Nothing Yet! Please add Santas");
            if (allSantas.size() == 0){
                emptyGroup.setVisibility(View.VISIBLE);
            } else {
                emptyGroup.setVisibility(View.INVISIBLE);
            }
        } else {
            emptyGroup.setText("Nothing Yet! Please add a group");

                if (groupsInfo.size() == 0) {
                    emptyGroup.setVisibility(View.VISIBLE);
                } else {
                    emptyGroup.setVisibility(View.INVISIBLE);
                }

        }
    }


//Update display will populate the view depending on if the user selected all or groups in the spinner
    protected void updateDisplay() {
        //Gets list view
        listView = (ListView) findViewById(R.id.listView);
        showEmptyLabel();

        if (currentView) {
            adapter = new ArrayAdapter<SantaInfo>(this, R.layout.custom_santa_listview, R.id.santaName, allSantas) {

                @Override
                public View getView(int position, View convertView, ViewGroup parent) {
                    View view = super.getView(position, convertView, parent);

                    //Getting text views from the xml files
                    TextView text1 = (TextView) view.findViewById(R.id.santaName);
                    TextView text2 = (TextView) view.findViewById(R.id.contactInfo);
                    TextView text3 = (TextView) view.findViewById(R.id.santaInterests);


                    text1.setText(allSantas.get(position).getmSantaName());
                    text2.setText(allSantas.get(position).getmContact());
                    if (allSantas.get(position).getmInterests().equals("")){
                        text3.setText("Interests not added");
                    } else {
                        text3.setText(allSantas.get(position).getmInterests());
                    }

                    return view;
                }
            };
        } else {
            adapter = new ArrayAdapter<GroupsInfo>(this, R.layout.custom_listview, R.id.groupName, groupsInfo) {

                @Override
                public View getView(int position, View convertView, ViewGroup parent) {
                    View view = super.getView(position, convertView, parent);

                    //Getting text views from the xml files
                    TextView text1 = (TextView) view.findViewById(R.id.groupName);
                    TextView text2 = (TextView) view.findViewById(R.id.groupInfo);

                    text1.setText(groupsInfo.get(position).getmGName());

                    if (groupsInfo.get(position).getmGInfo().isEmpty() || groupsInfo.get(position).getmGInfo() == null){
                        text2.setText("Additional information not included");
                    } else {
                        text2.setText(groupsInfo.get(position).getmGInfo());
                    }
                    return view;
                }

            };
        }

        //Setting adapter
        listView.setAdapter(adapter);


        //Runs when row is selected
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (currentView) {

                    for (int i = 0; i < groupsInfo.size(); i++) {
                        santaInfo = groupsInfo.get(i).getmSantas();
                        for (int a = 0; a < santaInfo.size(); a++) {
                            if (santaInfo.get(a).getmContact() == allSantas.get(position).getmContact()) {
                                group = i;
                                santa = a;
                            }
                        }
                    }
                    openSantaView();
                } else {
                    openView(position);
                }

            }
        });

        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                Snackbar.make(view, groupsInfo.get(position).getmGName(), Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
                return true;
            }
        });


    }

    //Open welcome intent
    public void welcome(){
        Intent intent = new Intent();
        intent.setClass(this, Welcome.class);
        startActivity(intent);
    }

    //Open user preferences intent
    public void prefs(){
        Intent intent = new Intent();
        intent.setClass(this, UserPrefs.class);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, 6);
    }

    //Open add group intent
    public void openAdd(){
        Intent intent = new Intent();
        intent.setClass(this, NewGroup.class);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, 1);
    }

    //Open santa view intent
    public void openView(int index){
        Intent intent = new Intent();
        intent.setClass(this, SantaView.class);
        intent.putExtra("Index", index);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, 3);
    }

    //Selected santaview intent
    public void openSantaView(){
        Intent intent = new Intent();
        intent.setClass(this, ViewSelectedSanta.class);
        intent.putExtra("santaIndex", santa);
        intent.putExtra("groupIndex", group);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, 0);
    }

    //Open add santa intent
    public void openSantaAdd(){
        Intent intent = new Intent();
        intent.setClass(this, Add.class);
        intent.putExtra("groupIndex", group);
        intent.putExtra("showPicker", true);
        intent.putExtra("groupsData", groupsInfo);
        startActivityForResult(intent, 4);
    }

    //Checks if file exists
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

   //will read file from the read and write class
    public ArrayList<GroupsInfo> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = getData.readFile(fin);
        return groupsInfo;
    }

}
