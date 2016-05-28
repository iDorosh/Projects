package com.idorosh.androidusersdata;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Shader;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.LogInCallback;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.ProgressCallback;
import com.parse.SaveCallback;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.text.ParseException;

public class Register extends AppCompatActivity {
    String currentEmail;
    String currentPassword;
    String currentUsername;

    EditText usernameField;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);


        //Getting current email and password from the login activity
        currentEmail = getIntent().getStringExtra("email");
        currentPassword = getIntent().getStringExtra("password");

        //User text fields
        usernameField = (EditText) findViewById(R.id.createUsername);
        EditText email = (EditText) findViewById(R.id.createEmail);
        EditText password = (EditText) findViewById(R.id.createPassword);

        //Setting text field text
        email.setText(currentEmail);
        password.setText(currentPassword);

        //Setting custom text
        TextView tx = (TextView)findViewById(R.id.createAccount);

        Typeface custom_font = Typeface.createFromAsset(getAssets(), "fonts/billabong.ttf");

        tx.setTypeface(custom_font);


        Button createButton = (Button) findViewById(R.id.register_button);
        createButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (usernameField.getText().toString().equals("")) {
                    usernameField.setError("Please enter a Name");
                    usernameField.requestFocus();
                } else {
                    Login(currentEmail, currentPassword);
                }
            }
        });
    }

    //Will login the current user
    public void Login(String username, String password){
        currentUsername = usernameField.getText().toString();
        ParseUser currentUser = ParseUser.getCurrentUser();

        //will set a name for the user
        if (currentUser != null) {
            currentUser.put("name", currentUsername);
            currentUser.saveInBackground(new SaveCallback() {
                public void done(com.parse.ParseException e) {
                    // TODO Auto-generated method stub
                    if (e != null) {

                    } else {
                    }
                }
            });
        } else {
        }

        //Will login the user
        ParseUser.logInInBackground(username, password, new LogInCallback() {
            @Override
            public void done(ParseUser user, com.parse.ParseException e) {
                if (user != null) {
                    System.out.println(e);
                    Intent intent = new Intent();
                    intent.setClass(Register.this, MainActivity.class);
                    startActivity(intent);
                    finish();
                } else {
                    System.out.println(e);
                }
            }

        });
    }

}
