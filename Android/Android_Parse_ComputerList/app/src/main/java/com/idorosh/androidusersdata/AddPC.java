package com.idorosh.androidusersdata;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.ContextThemeWrapper;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class AddPC extends AppCompatActivity {

    //Text fields and Strings to hold text field values
    EditText mb;
    EditText cpu;
    EditText pcCase;
    EditText gpu;
    EditText ram;
    EditText storage;
    EditText title;

    String mbText = "";
    String cpuText = "";
    String caseText = "";
    String gpuText = "";
    String ramText = "";
    String storageText = "";
    String titleText = "";

    EditText mbPrice;
    EditText cpuPrice;
    EditText pcCasePrice;
    EditText gpuPrice;
    EditText ramPrice;
    EditText storagePrice;

    String mbPriceText = "0";
    String cpuPriceText = "0";
    String casePriceText = "0";
    String gpuPriceText = "0";
    String ramPriceText = "0";
    String storagePriceText = "0";

    //To check if the user is editing the information
    Boolean edit = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_pc);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //References for the text fields
        mb = (EditText) findViewById(R.id.addMotherboard);
        cpu = (EditText) findViewById(R.id.addCPU);
        pcCase = (EditText) findViewById(R.id.addCase);
        gpu = (EditText) findViewById(R.id.addGPU);
        ram = (EditText) findViewById(R.id.addRam);
        storage = (EditText) findViewById(R.id.addStorage);
        title = (EditText) findViewById(R.id.addTitle);

        mbPrice = (EditText) findViewById(R.id.addMotherboardPrice);
        cpuPrice = (EditText) findViewById(R.id.addCPUPrice);
        pcCasePrice = (EditText) findViewById(R.id.addCasePrice);
        gpuPrice = (EditText) findViewById(R.id.addGPUPrice);
        ramPrice = (EditText) findViewById(R.id.addRamPrice);
        storagePrice = (EditText) findViewById(R.id.addStoragePrice);

        edit = getIntent().getBooleanExtra("edit", false);

        //Checking if user is editing and sets the fields to the pc components and prices
        if (edit == true){
            setText();
        } else {
        }

        //Setting a custom font for the add build title
        TextView tx = (TextView)findViewById(R.id.addPC);

        Typeface custom_font = Typeface.createFromAsset(getAssets(), "fonts/billabong.ttf");

        tx.setTypeface(custom_font);
        tx.setText("Create Build");

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_add, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //Will save the current build
        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            save();
        }

        return super.onOptionsItemSelected(item);
    }

    //Will run if the user is editing the information and set the proper textfield text
    public void setText(){
        ParseUser currentUser = ParseUser.getCurrentUser();
        final ParseObject computers = currentUser.getParseObject("computers");
        if (computers != null) {
            computers.fetchInBackground(new GetCallback<ParseObject>() {
            public void done(ParseObject object, ParseException e) {
                if (e == null) {
                    mb.setText(computers.getString("motherboard"));
                    cpu.setText(computers.getString("cpu"));
                    pcCase.setText(computers.getString("case"));
                    gpu.setText(computers.getString("gpu"));
                    ram.setText(computers.getString("ram"));
                    storage.setText(computers.getString("storage"));
                    title.setText(computers.getString("title"));

                    mbPrice.setText(Integer.toString(computers.getInt("motherboardPrice")));
                    cpuPrice.setText(Integer.toString(computers.getInt("cpuPrice")));
                    pcCasePrice.setText(Integer.toString(computers.getInt("casePrice")));
                    gpuPrice.setText(Integer.toString(computers.getInt("gpuPrice")));
                    ramPrice.setText(Integer.toString(computers.getInt("ramPrice")));
                    storagePrice.setText(Integer.toString(computers.getInt("storagePrice")));
                }
            }
        });
        }
    }

    //Save will get all the textfield text and save them to strings
    public void save(){
        if (title.getText().toString().equals("")){
            Toast.makeText(AddPC.this, "Please include build name", Toast.LENGTH_SHORT).show();
        } else {
            final AlertDialog alert = new AlertDialog.Builder(
                    new ContextThemeWrapper(this,android.R.style.TextAppearance_Theme))
                    .create();
            alert.setTitle("Save Build");
            alert.setMessage("Would You like to save the current build");
            alert.setCancelable(true);
            alert.setCanceledOnTouchOutside(false);

            alert.setButton(DialogInterface.BUTTON_POSITIVE, "Yes",
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {

                            mbText = mb.getText().toString();
                            cpuText = cpu.getText().toString();
                            caseText = pcCase.getText().toString();
                            gpuText = gpu.getText().toString();
                            ramText = ram.getText().toString();
                            storageText = storage.getText().toString();
                            titleText = title.getText().toString();


                            if (mbPrice.getText().toString().equals("")){
                                mbPriceText = "0";
                            }else {
                                mbPriceText = mbPrice.getText().toString();
                            }

                            if (cpuPrice.getText().toString().equals("")){
                                cpuPriceText = "0";
                            }else {
                                cpuPriceText = cpuPrice.getText().toString();
                            }

                            if (pcCasePrice.getText().toString().equals("")){
                                casePriceText = "0";
                            }else {
                                casePriceText = pcCasePrice.getText().toString();
                            }

                            if (gpuPrice.getText().toString().equals("")){
                                gpuPriceText = "0";
                            }else {
                                gpuPriceText = gpuPrice.getText().toString();
                            }

                            if (ramPrice.getText().toString().equals("")){
                                ramPriceText = "0";
                            }else {
                                ramPriceText = ramPrice.getText().toString();
                            }

                            if (storagePrice.getText().toString().equals("")){
                                storagePriceText = "0";
                            }else {
                                storagePriceText = storagePrice.getText().toString();
                            }

                            addData();
                        }
                    });

            alert.setButton(DialogInterface.BUTTON_NEGATIVE, "Cancel",
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            //Simple closes the alert dialog
                        }
                    });
            alert.show();
        }
    }

    public void addData(){

        //Getting the current user and setting the computer object under their account to all the data in the add build fields

        ParseUser currentUser = ParseUser.getCurrentUser();


        ParseObject computers = new ParseObject("Computer");
        computers.put("motherboard", mbText);
        computers.put("motherboardPrice", Integer.valueOf(mbPriceText));
        computers.put("cpu", cpuText);
        computers.put("cpuPrice", Integer.valueOf(cpuPriceText));
        computers.put("case", caseText);
        computers.put("casePrice", Integer.valueOf(casePriceText));
        computers.put("gpu", gpuText);
        computers.put("gpuPrice", Integer.valueOf(gpuPriceText));
        computers.put("ram", ramText);
        computers.put("ramPrice", Integer.valueOf(ramPriceText));
        computers.put("storage", storageText);
        computers.put("storagePrice", Integer.valueOf(storagePriceText));
        computers.put("title", titleText);

        computers.saveInBackground(new SaveCallback() {
            @Override
            public void done(ParseException e) {
                if (e != null) {
                    System.out.println(e.getCode());
                }
            }
        });

        //Will check if the user is null
        if (currentUser != null) {
            currentUser.put("computers", computers);
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

        //Return intent will refresh the main screen
        Intent returnIntent = new Intent();
        returnIntent.setClass(this, MainActivity.class);
        setResult(RESULT_OK, returnIntent);
        Toast.makeText(this, "Saved", Toast.LENGTH_LONG).show();
        finish();

    }


}
