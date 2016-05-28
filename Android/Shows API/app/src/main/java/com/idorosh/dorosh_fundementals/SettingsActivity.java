package com.idorosh.dorosh_fundementals;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.WindowManager;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by iDorosh on 10/8/15.
 */
public class SettingsActivity extends Activity{

    WriteAndRead saved = new WriteAndRead();

    @Override
      protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //Setting detail activity xml file as current view
        setContentView(R.layout.settings_layout);

        getFragmentManager().beginTransaction().replace(android.R.id.content,
                new SettingsFragment()).commit();


    }

    public String saveFile(ArrayList info) throws IOException {
        FileOutputStream fos = openFileOutput("test.dat", MODE_PRIVATE);
        saved.createFile(fos, info);
        return null;
    }


}
