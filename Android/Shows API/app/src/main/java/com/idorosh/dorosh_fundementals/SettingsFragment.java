package com.idorosh.dorosh_fundementals;

import android.os.Bundle;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.widget.Toast;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

public class SettingsFragment extends PreferenceFragment {

    ArrayList<Info> clearList = new ArrayList<>();


    @Override
    public void onCreate(Bundle _savedInstanceState) {
        super.onCreate(_savedInstanceState);

        addPreferencesFromResource(R.xml.settings);
    }

    @Override
    public void onActivityCreated(Bundle _savedInstanceState) {
        super.onActivityCreated(_savedInstanceState);
        // Find preference by key
        Preference pref = findPreference("PREF_CLICK");
        pref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
            @Override
            public boolean onPreferenceClick(Preference _pref) {
                System.out.println("Information Cleared");
                try {
                    ((SettingsActivity)getActivity()).saveFile(clearList);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return true;
            }
        });
    }




}
