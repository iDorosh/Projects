package idorosh.com.daydream;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.CheckBox;


public class Config extends Activity {

    //Shared Preferences to store the check box booleans
    SharedPreferences pref;
    //Editor to put values into shared preferences
    SharedPreferences.Editor prefEditor;

    //Check box references for wallpaper and clock type
    CheckBox check;
    CheckBox wallpaperCheck;

    //Preference mode to get shared preferences
    int prefMode = 0;

    //Preferences unique name
    String name = "Prefs";

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_config);

        //Getting shared preference to determine if the the check boxes should be checked and to set booleans
        pref = getSharedPreferences(name, prefMode);

        //Editor to add booleans
        prefEditor = pref.edit();

        //Reference for the clock check box and onclick listener
        check = (CheckBox) findViewById(R.id.checkBox);
        check.setOnClickListener(current);

        //Reference for wallpaper check box and onclick listener
        wallpaperCheck = (CheckBox) findViewById(R.id.wallpaperChecked);
        wallpaperCheck.setOnClickListener(current);

        //Setting checkbox state based on shared preferences
        if (pref.getBoolean("Checked", false)){
            check.setChecked(true);
        } else {
            check.setChecked(false);
        }

        if (pref.getBoolean("wallpaperChecked", false)){
            wallpaperCheck.setChecked(true);
        } else {
            wallpaperCheck.setChecked(false);
        }



    }

    //Setting booleans in preferences based on clock and wallpaper checkboxes
    private View.OnClickListener current = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.checkBox) {
                if (check.isChecked()) {
                    prefEditor.putBoolean("Checked", true);
                    prefEditor.commit();
                } else {
                    prefEditor.putBoolean("Checked", false);
                    prefEditor.commit();
                }
            }
            if (v.getId() == R.id.wallpaperChecked){
                if (wallpaperCheck.isChecked()) {
                    prefEditor.putBoolean("wallpaperChecked", true);
                    prefEditor.commit();
                } else {
                    prefEditor.putBoolean("wallpaperChecked", false);
                    prefEditor.commit();
                }
            }
        }
    };

}
