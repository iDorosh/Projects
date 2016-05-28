package com.iandorosh.secretsanta;

//Ian Dorosh
//Secret Santa
//Application Deployment 2 1512

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.telephony.SmsManager;
import android.util.Log;
import android.view.ContextThemeWrapper;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

public class Send extends AppCompatActivity {

    //Current santa and current group
    int currentSanta;
    int currentGroup;

    //Array list for group, santa information, and sendinformation
    ArrayList<GroupsInfo> groupsInfo = new ArrayList<>();
    ArrayList<SantaInfo> santaInfo = new ArrayList<>();
    ArrayList<SendInfo> sendInfo = new ArrayList<>();

    //Text views and text fields
    TextView totalSantas;
    EditText groupInfo;
    EditText info;

    //Progress dialog
    ProgressDialog pDialog;

    //Amount of santas in group
    String santaCount;

    Context context;

    //Will allow to write to storage
    WriteAndRead write = new WriteAndRead();

    //to display proper label
    boolean email = false;
    boolean number = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_send);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //Dialog with proper paremeters
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!info.getText().toString().equals("")){
                    showConfirmationAlert("Send Messages", "Secret Santas will be drawn and the messages will be sent out. Would you like to continue", "Send", "Cancel");
                } else {
                    showConfirmationAlert("Send Messages", "Without additional Information\n\nSecret Santas will be drawn and the messages will be sent out. Would you like to continue", "Send", "Cancel");
                }
            }
        });

        currentSanta = getIntent().getExtras().getInt("santaIndex");
        currentGroup = getIntent().getExtras().getInt("groupIndex");

        //Total amount of santas
        totalSantas = (TextView) findViewById(R.id.totalSantas);
        groupInfo = (EditText) findViewById(R.id.additionalInfoField);

        //read file
        try {
            readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Setting santa info
        santaInfo = groupsInfo.get(currentGroup).getmSantas();

        info = (EditText) findViewById(R.id.additionalInfoField);

        santaCount = Integer.toString(santaInfo.size());

        context = this;

        //Figuring out contact type
        contactTypeText();

        //Populate view
        updateDisplay();
    }

    //What contact type the is
    public void contactTypeText(){
        TextView contactTypeLabel = (TextView) findViewById(R.id.contactTypeLabel);
        for (int i = 0; i < santaInfo.size(); i++) {
            if (santaInfo.get(i).getmContactType().equals("Number")){
                number = true;
            }
            if (santaInfo.get(i).getmContactType().equals("Email")){
                email = true;
            }
        }
        if (number){
            contactTypeLabel.setText("Text");
        }
        if (email){
            contactTypeLabel.setText("Email");
        }
        if (number && email){
            contactTypeLabel.setText("Text and Email");
        }
        number = false;
        email = false;
    }

    //Setting text
    public void updateDisplay(){
        totalSantas.setText(Integer.toString(santaInfo.size()));
        groupInfo.setText(groupsInfo.get(currentGroup).getmGInfo());
    }

    //Reading file
    public ArrayList<GroupsInfo> readFile() throws IOException {
        WriteAndRead getData = new WriteAndRead();
        FileInputStream fin = openFileInput("groups.data");
        groupsInfo = getData.readFile(fin);
        return groupsInfo;
    }

    //Saving file
    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("groups.data", MODE_PRIVATE);
        write.createFile(fos, info);
        return null;
    }

    //Dialog to make sure the user wants to send the messages
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
                        if (title.equals("Send Messages")){
                            pairSantas();
                        }

                        if (confirm.equals("Keep")){
                            finish();
                        }
                        alert.dismiss();
                    }
                });

        alert.setButton(DialogInterface.BUTTON_NEGATIVE, cancel,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        if (cancel.equals("Remove")) {
                            groupsInfo.remove(currentGroup);
                            try {
                                saveFile(groupsInfo);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            deleteGroup();
                        }
                    }
                });

        alert.show();
    }

    //Deleteing group after sending messages
    private void deleteGroup(){
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, SantaView.class);
        returnIntent.putExtra("current", currentGroup);
        returnIntent.putExtra("groupsData", groupsInfo);
        setResult(RESULT_OK, returnIntent);
        finish();
    }

    //Pairing santas
    public void pairSantas() {
        String santaName;
        String santaContact;
        String reciever;
        String recieverInterests;
        String additionalInfo;
        String santaContactType;

        //will randomize order of the array list
        Collections.shuffle(santaInfo);

        //Will assign the second santa to the first one the third to the second and so on. Last one will get the first one
        for (int i = 0; i < santaInfo.size(); i++) {
            santaName = santaInfo.get(i).getmSantaName();
            santaContact = santaInfo.get(i).getmContact();
            santaContactType = santaInfo.get(i).getmContactType();

            if (i == santaInfo.size()-1){
                reciever = santaInfo.get(0).getmSantaName();
                recieverInterests = santaInfo.get(0).getmInterests();
            } else {
                reciever = santaInfo.get(i+1).getmSantaName();
                recieverInterests = santaInfo.get(i+1).getmInterests();
            }

            additionalInfo = info.getText().toString();

            String generatedMessage;

            //Generated strings based on the information that the user provided
            if (additionalInfo.equals("")){
                generatedMessage = "Hello " + santaName + "!\n" + "The name you received for Secret Santa is " + reciever + ".\nTheir interests include " + recieverInterests;

                if (recieverInterests.equals("")){
                    generatedMessage = "Hello " + santaName + "!\n" + "The name you received for Secret Santa is " + reciever;
                }

            } else {
                if (recieverInterests.equals("")){
                    generatedMessage = "Hello " + santaName + "!\n" + "The name you received for Secret Santa is " + reciever + ".\nAdditional Information: " + additionalInfo;
                } else {

                    generatedMessage = "Hello " + santaName + "!\n" + "The name you received for Secret Santa is " + reciever + ".\nTheir interests include " + recieverInterests + ".\nAdditional Information: " + additionalInfo;
                }
            }
            sendInfo.add(new SendInfo(santaName, santaContact, generatedMessage, santaContactType));

        }

        //Will start the async task
        SendDrawing send = new SendDrawing();
        send.execute();
    }


    public class SendDrawing extends AsyncTask<Void, Void, Void> {

        @Override
        protected void onPreExecute() {
            //Progress dialog to display messages
            pDialog = new ProgressDialog(Send.this);
            pDialog.setMessage("Sending messages ....");
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Void doInBackground(Void... params) {
            //Will either send an email or text message based on contact type
            for (int i = 0; i < sendInfo.size(); i++) {
                if (sendInfo.get(i).getmType().equals("Email")) {
                    try {
                        GMailSender sender = new GMailSender("secretsantaapdii@gmail.com", "Wpy-Wzh-2pH-RPU");
                        sender.sendMail("Secret Santa Drawing",
                                sendInfo.get(i).getmString(),
                                "secretsantaapdii@gmail.com",
                                sendInfo.get(i).getmRecipientContactInfo());
                    } catch (Exception e) {
                        Log.e("SendMail", e.getMessage(), e);
                    }
                } else {
                    SmsManager sm = SmsManager.getDefault();
                    ArrayList<String> parts = sm.divideMessage(sendInfo.get(i).getmString());
                    sm.sendMultipartTextMessage(sendInfo.get(i).getmRecipientContactInfo()
                            , null, parts, null, null);

                }
            }
            return null;
        }
        @Override
        protected void onPostExecute(Void result) {
            //will dismiss progress dialog and show a messages sent dialog
            pDialog.dismiss();
            showConfirmationAlert(santaCount+"/"+santaCount+" Messages Sent", "Would you like to remove the group?", "Keep", "Remove");


        }
    }

}
