/**
 * Created by Ian Dorosh on 11/12/15.
 * MDF 3 1511
 * Week 3 Widget
 */

package com.idorosh.i_dorosh_widget;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ContentResolver;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class Details extends Activity {

    //Will Store the sellected phones information
    String item1;
    String item2;
    String item3;
    String item4;
    int currentIndex;

    //Text views for the labels under the text fields
    TextView detailsItem1;
    TextView detailsItem2;
    TextView detailsItem3;
    TextView detailsItem4;

    //Will either hold data from the mainactivity or the widget depending on which one is selected
    ArrayList<Info> itemsInfo = new ArrayList<>();



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_details);

        Intent intent = getIntent();

        //Setting text views
        detailsItem1 = (TextView) findViewById(R.id.detail1Text);
        detailsItem2 = (TextView) findViewById(R.id.detail2Text);
        detailsItem3 = (TextView) findViewById(R.id.detail3Text);
        detailsItem4 = (TextView) findViewById(R.id.detail4Text);

            //Will be used to determine what is opening this activity
            String caller = getIntent().getStringExtra("caller");

        //if main activity opens detail activity then items info is the same as the arraylist in main activity
            if (caller.equals("activity")){
                itemsInfo = (ArrayList<Info>) getIntent().getSerializableExtra("info");
                currentIndex = getIntent().getExtras().getInt("int");

                //Setting variables with the phones information
                item1 = itemsInfo.get(currentIndex).getmPhoneName();
                item2 = itemsInfo.get(currentIndex).getmPhoneOS();
                item3 = itemsInfo.get(currentIndex).getmPhoneCarrier();
                item4 = itemsInfo.get(currentIndex).getmPhonePrice();



            }else {
                //Else the items info array will equal data coming from the widget
                Info items = (Info)intent.getSerializableExtra("info");
                if(items == null) {
                    finish();
                    return;
                }

                //Setting variable with the phones information
                item1 = items.getmPhoneName();
                item2 = items.getmPhoneOS();
                item3 = items.getmPhoneCarrier();
                item4 = items.getmPhonePrice();



            }
        //Will populate the display
        showUI();

    }

    //Will populate the ui
    public void showUI(){
        detailsItem1.setText(item1);
        detailsItem2.setText(item2);
        detailsItem3.setText(item3);
        detailsItem4.setText(item4);
    }
}
