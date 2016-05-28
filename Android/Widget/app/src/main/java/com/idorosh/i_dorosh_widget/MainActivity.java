/**
 * Created by Ian Dorosh on 11/12/15.
 * MDF 3 1511
 * Week 3 Widget
 */

package com.idorosh.i_dorosh_widget;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;


public class MainActivity extends Activity {

    //Items info will hold all the information that is pulled from the phone.data file
    ArrayList<Info> itemsInfo = new ArrayList<>();

    //Requests for getting result intents
    public static final int addRequest = 1;

    //Global list and text views also the adapter
    ListView listView;
    ArrayAdapter adapter;
    TextView lv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Label for list is empty
        lv = (TextView) findViewById(R.id.listEmpty);

        //Reading a file to get the phone information
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //List check will display list empty if itemsinfo is empty and will remove it if its not empty
        listCheck();

        //Method to display the listview
        loadList();
    }

    @Override
    protected void onResume() {
        super.onResume();
        //refresh list on resume
        //Will reload the listview on resume;
        adapter.notifyDataSetChanged();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        //Action icon to add a phone
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        addData();
        return super.onOptionsItemSelected(item);
    }

    //Check list will display list empty label
    public void listCheck(){
        if (!itemsInfo.isEmpty()){
            lv.setVisibility(View.INVISIBLE);
        } else {
            lv.setVisibility(View.VISIBLE);
        }
    }

    //On activity result will set the itemsInfo to current updated arraylist from the add class and also adds it to the adapter
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        //Adding the new array list to the arraylist itemsInfo then adding the array list to the adapter
        if (resultCode == RESULT_OK && requestCode == addRequest) {
            itemsInfo = ((ArrayList<Info>) data.getSerializableExtra("itemsInfo"));
            adapter.add(itemsInfo);

            listCheck();
        }

    }

    //Will load the list view with the phone names from the itemsInfo array
    public void loadList() {
        listView = (ListView) findViewById(R.id.listView);
        adapter = new ArrayAdapter<Info>(this, android.R.layout.simple_list_item_1, android.R.id.text1, itemsInfo) {

            @Override
            public View getView(int position, View convertView, ViewGroup parent) {

                View view = super.getView(position, convertView, parent);
                TextView text1 = (TextView) view.findViewById(android.R.id.text1);

                //Setting the text in the listview to the corresponding phones.
                text1.setText(itemsInfo.get(position).getmPhoneName());

                return view;
            }

        };
        //Setting adapter
        listView.setAdapter(adapter);

        //Running pass data method once item is clicked
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                passData(position);
            }
        });

    }

    //Creating intent and putting extras into the intent then starting Details activity
    public void passData(int index){
        Intent intent = new Intent();
        intent.setClass(this, Details.class);
        intent.putExtra("info", itemsInfo);
        intent.putExtra("int", index);
        //To verify what class is calling the intent
        intent.putExtra("caller", "activity" );
        startActivity(intent);
    }

    //Will start the add class
    public void addData(){
        Intent intent = new Intent();
        intent.setClass(this, Add.class);
        startActivityForResult(intent, addRequest);
    }

    //Will call the method on ReadAndWrite class to read phone.data
    public ArrayList<Info> readFile() throws IOException {
        ReadAndWrite read = new ReadAndWrite();
        FileInputStream fin = openFileInput("phone.data");
        itemsInfo = read.readFile(fin);
        return itemsInfo;
    }

}
