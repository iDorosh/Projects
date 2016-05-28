package idorosh.com.daydream;

import android.content.SharedPreferences;
import android.view.View;
import android.widget.AnalogClock;
import android.widget.ImageView;
import android.widget.TextClock;

public class DayDream extends android.service.dreams.DreamService {

    //Preference to get booleans based on the checked boxes
    SharedPreferences pref;
    int prefMode = 0;

    public DayDream() {
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        setContentView(R.layout.layout_daydream);

        setInteractive(false);
        setFullscreen(true);

        //Getting Prefs shared preference
        pref = getSharedPreferences("Prefs", prefMode);

        //References for the digital clock and the text clock
        TextClock digitalClock = (TextClock) findViewById(R.id.digitalClock);
        AnalogClock analogClock = (AnalogClock) findViewById(R.id.analogClock);

        //Reference for the background
        ImageView background = (ImageView) findViewById(R.id.backGround);

        //Setting visibility of the wallpaper and the clocks based on the booleans from the shared preferences
        if (pref.getBoolean("Checked", false)) {
            digitalClock.setVisibility(View.INVISIBLE);
            analogClock.setVisibility(View.VISIBLE);
        } else {
            digitalClock.setVisibility(View.VISIBLE);
            analogClock.setVisibility(View.INVISIBLE);
        }

        if (pref.getBoolean("wallpaperChecked", false)) {
            background.setVisibility(View.VISIBLE);
        } else {
            background.setVisibility(View.INVISIBLE);
        }
    }


}
