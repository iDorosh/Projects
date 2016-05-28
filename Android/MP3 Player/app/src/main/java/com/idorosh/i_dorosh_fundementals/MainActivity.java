/**
 * Created by Ian Dorosh on 10/26/15.
 * MDF 3 1511
 * Week 1 Fundamentals
 */

package com.idorosh.i_dorosh_fundementals;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;



public class MainActivity extends AppCompatActivity implements ServiceConnection, SongInfoFragment.musicControls {

    //Intent for Services
    Intent intent;
    Services mService;

    //Song labels
    TextView songTitle;
    TextView artistLabel;
    ImageView albumCover;
    SeekBar seekBar;


    private final Handler handler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //Starting a new intent for Services
        intent = new Intent(this, Services.class);
        startService(intent);

        //Setting text views
        songTitle = (TextView) findViewById(R.id.currentSong);
        artistLabel = (TextView) findViewById(R.id.artistLabel);
        albumCover = (ImageView) findViewById(R.id.ablumCover);

        //Reference to the seek bar and setting it to invisible.
        seekBar = (SeekBar) findViewById(R.id.seekBar);
        seekBar.setVisibility(View.INVISIBLE);

        getSupportActionBar().hide();
    }


    @Override
    protected void onStart() {
        super.onStart();
        //Binding service
        Intent intent = new Intent(this, Services.class);
        bindService(intent, this, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onStop() {
        super.onStop();
        //Unbinding Service
        unbindService(this);
    }

    public void onServiceConnected(ComponentName name, IBinder service) {
        Services.BoundServiceBinder binder = (Services.BoundServiceBinder)service;
        //Getting service and setting up media player
        mService = binder.getService();
        mService.startmPlayer();
        //Updating UI if media player is playing
        if (mService.mPlayer.isPlaying()) {
            updateUI();
        }
    }

    //Updating UI with song title and artist;
    public void updateUI(){
        songTitle.setText(mService.songs.get(mService.currentSongInt).getmTitle().toString());
        artistLabel.setText("Artist: " + mService.songs.get(mService.currentSongInt).getmArtist().toString());
        albumCover.setBackgroundResource(mService.songs.get(mService.currentSongInt).getmCover());
        seekBar.setMax(mService.mPlayer.getDuration());

        seekBar.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                seekChange(v);
                return false;
            }
        });

        updateSeekBar();
        seekBar.setVisibility(View.VISIBLE);
    }


    //Interface methods
    @Override
    public void play() {
        //Playing song, creating a notification in services and updating ui
        mService.play();
        mService.createNotification();
        updateUI();
    }

    @Override
    public void pause() {
        //Pausing media in services
        mService.pause();
    }

    @Override
    public void stop() {
        //Stoping media and removing song title
        mService.stop();
        songTitle.setText("");
        artistLabel.setText("");
        albumCover.setBackgroundResource(R.drawable.placeholder);
        seekBar.setVisibility(View.INVISIBLE);
        seekBar.setProgress(0);
    }

    @Override
    public void next() {
        //Going to next song and updating ui
        mService.next();
        updateUI();
    }

    @Override
    public void previous() {
        //Previous song and updating ui
        mService.previous();
        updateUI();
    }

    @Override
    public void shuffle() {
        mService.shuffle = !mService.shuffle;
    }


    //Scrub to position in media player depending on the seekbar location
    private void seekChange(View v){
        if(mService.mPlayer.isPlaying()){
            SeekBar sb = (SeekBar)v;
            mService.mPlayer.seekTo(sb.getProgress());
        }
    }


    //Setting postition of the seekbar based on playback
    public void updateSeekBar() {
        seekBar.setProgress(mService.mPlayer.getCurrentPosition());
        Runnable notification = new Runnable() {
            public void run() {
                updateSeekBar();
            }
        };
        handler.postDelayed(notification, 1000);
    }



    public void onServiceDisconnected(ComponentName name) {

    }
}
