package com.idorosh.i_dorosh_multiactivity;



import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class MainActivity extends FragmentActivity {
    int test = 0;
    List<Info> getList = new ArrayList<>();
    ReadAndWrite read = new ReadAndWrite();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        View myButton = findViewById(R.id.addButton);
        myButton.setOnClickListener(showAddScreen);
    }

    private View.OnClickListener showAddScreen = new View.OnClickListener() {

        @Override
        public void onClick(View v) {
            displayItems(test);
        }
    };

    void displayItems(int index){
        //Launches activity and passes the index through with an intent.
        Intent intent = new Intent();
        intent.setClass(this, AddActivity.class);
        intent.putExtra("index", index);
        startActivity(intent);
    }


    public List<Info> readFile() throws IOException {
        FileInputStream fin = openFileInput("test.dat");
        getList = read.readFile(fin);
        System.out.println(getList.get(0).getmTitle());
        return getList;
    }
}



