package com.idorosh.androidusersdata;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.ContextThemeWrapper;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;


public class MainActivity extends AppCompatActivity {


    //Text views, strings and ints to hold data
    TextView mb;
    TextView cpu;
    TextView pcCase;
    TextView gpu;
    TextView ram;
    TextView storage;
    TextView title;

    TextView nothing;
    TextView tx;

    String mbText;
    String cpuText;
    String caseText;
    String gpuText;
    String ramText;
    String storageText;
    String titleText = "";

    int mbPriceText;
    int cpuPriceText;
    int casePriceText;
    int gpuPriceText;
    int ramPriceText;
    int storagePriceText;

    //Will be used to hide and show the build
    RelativeLayout everything;

    //Will be used to search for the pc component
    String url;

    //Used to add a build
    FloatingActionButton fab;

    //Buttons to search for the component
    Button findMB;
    Button findCase;
    Button findCPU;
    Button findGPU;
    Button findRAM;
    Button findStorage;

    Boolean search = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        updateDisplay();


        fab = (FloatingActionButton) findViewById(R.id.viewFab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent();
                intent.setClass(MainActivity.this, AddPC.class);
                startActivityForResult(intent, 0);
            }
        });

        //Text views to display the componenets
        mb = (TextView) findViewById(R.id.buildMotherboard);
        cpu = (TextView) findViewById(R.id.buildCPU);
        pcCase = (TextView) findViewById(R.id.buildCase);
        gpu = (TextView) findViewById(R.id.buildGPU);
        ram = (TextView) findViewById(R.id.buildRam);
        storage = (TextView) findViewById(R.id.buildStorage);
        nothing = (TextView) findViewById(R.id.nothing);
        title = (TextView) findViewById(R.id.buildTitle);

        //Buttons to search for componenets
        findMB = (Button) findViewById(R.id.findMB);
        findMB.setOnClickListener(findClicked);

        findCase = (Button) findViewById(R.id.findCase);
        findCase.setOnClickListener(findClicked);

        findCPU = (Button) findViewById(R.id.findCPU);
        findCPU.setOnClickListener(findClicked);

        findGPU = (Button) findViewById(R.id.findGPU);
        findGPU.setOnClickListener(findClicked);

        findRAM = (Button) findViewById(R.id.findRAM);
        findRAM.setOnClickListener(findClicked);

        findStorage = (Button) findViewById(R.id.findStorage);
        findStorage.setOnClickListener(findClicked);

        //Relative Layout
        everything = (RelativeLayout) findViewById(R.id.showEverything);


        //Setting custom text font
        tx = (TextView)findViewById(R.id.helloText);

        Typeface custom_font = Typeface.createFromAsset(getAssets(), "fonts/billabong.ttf");

        ParseUser currentUser = ParseUser.getCurrentUser();

        tx.setText("Hello "+currentUser.getString("name"));
        tx.setTypeface(custom_font);


    }

    //Checking if the component has been added before opening a search on button click
    View.OnClickListener findClicked = new View.OnClickListener() {

        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.findMB){
                if (mb.getText().toString().equals("Not Selected")){
                    search = false;
                }
                url = "http://google.com/#q="+mbText.replaceAll(" ","+");
            }
            if (v.getId() == R.id.findCase){
                if (pcCase.getText().toString().equals("Not Selected")){
                    search = false;
                }
                url = "http://google.com/#q="+caseText.replaceAll(" ","+");
            }
            if (v.getId() == R.id.findCPU){
                if (cpu.getText().toString().equals("Not Selected")){
                    search = false;
                }
                url = "http://google.com/#q="+cpuText.replaceAll(" ","+");
                System.out.println(url);
            }
            if (v.getId() == R.id.findGPU){
                if (gpu.getText().toString().equals("Not Selected")){
                    search = false;
                }
                url = "http://google.com/#q="+gpuText.replaceAll(" ","+");
            }
            if (v.getId() == R.id.findRAM){
                if (ram.getText().toString().equals("Not Selected")){
                    search = false;
                }
                url = "http://google.com/#q="+ramText.replaceAll(" ","+");
            }
            if (v.getId() == R.id.findStorage){
                if (ram.getText().toString().equals("Not Selected")){
                    search = false;
                }
                url = "http://google.com/#q="+storageText.replaceAll(" ","+");
            }

            if (search == true) {
                //Will bring up the search
                Intent i = new Intent(Intent.ACTION_VIEW);
                i.setData(Uri.parse(url));
                startActivity(i);
            } else {
                Toast.makeText(MainActivity.this, "Please add component", Toast.LENGTH_SHORT).show();
            }
            search = true;
        }
    };


    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //will update display
        if (resultCode == RESULT_OK && requestCode == 0) {
            updateDisplay();
        }
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_scrolling, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {

            //Alert Dialog to sign out of the account
            final AlertDialog alert = new AlertDialog.Builder(
                    new ContextThemeWrapper(this,android.R.style.TextAppearance_Theme))
                    .create();
            alert.setTitle("Sign Out");
            alert.setMessage("Sign out of account?");
            alert.setCancelable(true);
            alert.setCanceledOnTouchOutside(false);

            alert.setButton(DialogInterface.BUTTON_POSITIVE, "Yes",
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            //Will logout current user
                            ParseUser currentUser = ParseUser.getCurrentUser();
                            currentUser.logOut();

                            Intent intent = new Intent();
                            intent.setClass(MainActivity.this, LoginActivity.class);
                            startActivity(intent);
                            finish();
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
        //Dialog to remove the current build
        if (id == R.id.action) {
            if (titleText.equals("")) {
                Toast.makeText(MainActivity.this, "Please add build", Toast.LENGTH_LONG).show();
            } else {
                final AlertDialog alert = new AlertDialog.Builder(
                        new ContextThemeWrapper(this, android.R.style.TextAppearance_Theme))
                        .create();
                alert.setTitle("Remove Build");
                alert.setMessage("Are you sure that you want to remove the build and all of its components");
                alert.setCancelable(true);
                alert.setCanceledOnTouchOutside(false);

                alert.setButton(DialogInterface.BUTTON_POSITIVE, "Yes",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                ParseUser currentUser = ParseUser.getCurrentUser();
                                currentUser.remove("computers");

                                currentUser.saveInBackground();
                                everything.setVisibility(View.INVISIBLE);
                                nothing.setVisibility(View.VISIBLE);
                                fab.setVisibility(View.VISIBLE);
                                updateDisplay();
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

        //Add new pc when the add fab is clicked
        if (id == R.id.action_edit) {
            if (titleText != "") {
                Intent intent = new Intent();
                intent.setClass(MainActivity.this, AddPC.class);
                intent.putExtra("edit", true);
                startActivityForResult(intent, 0);
            } else {
                Toast.makeText(MainActivity.this, "Please add build", Toast.LENGTH_LONG).show();
            }
        }

        return super.onOptionsItemSelected(item);
    }

    // will get the current computer for the user.
    protected void updateDisplay() {
        getComputers();

    }

    //Setting strings based of of the computers under the current user
    public void getComputers(){
        ParseUser currentUser = ParseUser.getCurrentUser();
        final ParseObject computers = currentUser.getParseObject("computers");
        if (computers != null) {
            computers.fetchInBackground(new GetCallback<ParseObject>() {
                public void done(ParseObject object, ParseException e) {
                    if (e == null) {
                        mbText = computers.getString("motherboard");
                        cpuText = computers.getString("cpu");
                        caseText = computers.getString("case");
                        gpuText = computers.getString("gpu");
                        ramText = computers.getString("ram");
                        storageText = computers.getString("storage");
                        titleText = computers.getString("title");

                        mbPriceText = computers.getInt("motherboardPrice");
                        cpuPriceText = computers.getInt("cpuPrice");
                        casePriceText = computers.getInt("casePrice");
                        gpuPriceText = computers.getInt("gpuPrice");
                        ramPriceText = computers.getInt("ramPrice");
                        storagePriceText = computers.getInt("storagePrice");

                        int price;

                        price = mbPriceText + cpuPriceText + casePriceText + gpuPriceText + ramPriceText + storagePriceText;

                        TextView total = (TextView) findViewById(R.id.buildPrice);

                        total.setText("$" + Integer.toString(price));


                        //Setting Not Selected to components that haven't yet been added
                        if (mbText.equals("")) {
                            mb.setText("Not Selected");
                            findMB.setBackground(getDrawable(R.drawable.greyedout));
                        } else {
                            findMB.setBackground(getDrawable(R.drawable.roundbutton));
                            mb.setText(mbText);
                        }

                        if (cpuText.equals("")) {
                            cpu.setText("Not Selected");
                            findCPU.setBackground(getDrawable(R.drawable.greyedout));
                        } else {
                            findCPU.setBackground(getDrawable(R.drawable.roundbutton));
                            cpu.setText(cpuText);
                        }

                        if (caseText.equals("")) {
                            pcCase.setText("Not Selected");
                            findCase.setBackground(getDrawable(R.drawable.greyedout));
                        } else {
                            findCase.setBackground(getDrawable(R.drawable.roundbutton));
                            pcCase.setText(caseText);
                        }

                        if (gpuText.equals("")) {
                            gpu.setText("Not Selected");
                            findGPU.setBackground(getDrawable(R.drawable.greyedout));
                        } else {
                            findGPU.setBackground(getDrawable(R.drawable.roundbutton));
                            gpu.setText(gpuText);
                        }

                        if (ramText.equals("")) {
                            ram.setText("Not Selected");
                            findRAM.setBackground(getDrawable(R.drawable.greyedout));
                        } else {
                            findRAM.setBackground(getDrawable(R.drawable.roundbutton));
                            ram.setText(ramText);
                        }

                        if (storageText.equals("")) {
                            storage.setText("Not Selected");
                            findStorage.setBackground(getDrawable(R.drawable.greyedout));
                        } else {
                            findStorage.setBackground(getDrawable(R.drawable.roundbutton));
                            storage.setText(storageText);
                        }

                        if (titleText.equals("")) {
                            title.setText("Title Not Set");
                        } else {
                            title.setText(titleText);
                        }

                        //Setting custom font to title
                        Typeface custom_font = Typeface.createFromAsset(getAssets(), "fonts/billabong.ttf");
                        title.setTypeface(custom_font);

                        //Setting visibility to proper views
                        nothing.setVisibility(View.INVISIBLE);
                        fab.setVisibility(View.INVISIBLE);
                        everything.setVisibility(View.VISIBLE);
                        tx.setVisibility(View.INVISIBLE);

                    } else {
                        //Setting visibility to proper views
                        nothing.setVisibility(View.VISIBLE);
                        nothing.setVisibility(View.VISIBLE);
                    }
                }
            });
        }


    }
}
