package com.idorosh.androidusersdata;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;

import com.parse.Parse;
import com.parse.ParseUser;

public class Application extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        //Will run on start up to initialize the parse
        Parse.initialize(this);

        //Will run the proper activity based on if the user is logged in
        ParseUser currentUser = ParseUser.getCurrentUser();
        if (currentUser != null) {
            Intent intent = new Intent();
            intent.setClass(Application.this, MainActivity.class);
            startActivity(intent);
            finish();
        } else {
            Intent intent = new Intent();
            intent.setClass(Application.this, LoginActivity.class);
            startActivity(intent);
            finish();
        }


    }

    //Will resume the proper activity
    @Override
    protected void onResume() {
        Intent intent = new Intent();
        intent.setClass(Application.this, MainActivity.class);
        startActivity(intent);
        finish();
        super.onResume();
    }
}
