/**
 * Created by Ian Dorosh on 10/26/15.
 * MDF 3 1511
 * Week 1 Fundamentals
 */

package com.idorosh.i_dorosh_fundementals;

import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Binder;
import android.os.IBinder;
import android.support.v7.app.NotificationCompat;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

public class Services extends Service implements MediaPlayer.OnPreparedListener{

    //Static int for notification ids
    private static final int FOREGROUND_NOTIFICATION = 0x01001;
    private static final int REQUEST_NOTIFY_LAUNCH = 0x02001;

    //Array list to hold song information
    ArrayList <Info> songs = new ArrayList<>();

    //Notification Builder
    NotificationCompat.Builder builder;

    Boolean shuffle = false;

    MediaPlayer mPlayer;

    //Directory will hold the uri except for the file name
    String directory;
    //Uri will hold entire URI
    Uri uri;

    //Represents the current song in the song Array list
    int currentSongInt = 0;
    int repeatSongCheck = 4;

    //Static ints to determine the media players current state
    private static final int STATE_IDLE = 1;
    private static final int STATE_INITIALIZED = 2;
    private static final int STATE_PREPARING = 3;
    private static final int STATE_PREPARED = 4;
    private static final int STATE_STARTED = 5;
    private static final int STATE_STOPPED = 6;
    //private static final int STATE_PLAYBACK_COMPLETE = 7;
    private static final int STATE_PAUSED = 8;

    //int to hold the current state of the media player
    private int mState;


    public class BoundServiceBinder extends Binder {public Services getService() {return Services.this;}}

    @Override
    public IBinder onBind(Intent intent) {
        return new BoundServiceBinder();
    }

    //runs at start creates the array list as well as the directory
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        songs.clear();
        songs.add(new Info("Dubstep", "bensound_dubstep", "Bensound", R.drawable.cover_dubstep));
        songs.add(new Info("Slowmotion", "bensound_slowmotion", "Bensound", R.drawable.cover_slowmotion));
        songs.add(new Info("Epic", "bensound_epic", "Bensound", R.drawable.cover_epic));

        directory = "android.resource://" + getPackageName() + "/raw/";

        return Service.START_NOT_STICKY;
    }

    //Will create the media player
    public void startmPlayer(){
        if (mPlayer == null) {
            mPlayer = new MediaPlayer();
            mPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mPlayer.setOnPreparedListener(this);
        }
    }


    //Checks state and plays song, changes state to started
    public void play() {
        if(mState != STATE_PAUSED) {
            playSong();
        } else {
            mPlayer.start();
            mState = STATE_STARTED;
        }

    }

    //Checks state and pauses song, changes state to paused
    public void pause() {
        if (mState == STATE_STARTED) {
            mPlayer.pause();
            mState = STATE_PAUSED;
        }

    }

    //Checks state and stops song, changes state to stopped
    public void stop() {
        if (mState == STATE_STARTED) {
            mPlayer.stop();
            mState = STATE_STOPPED;
            //Plays the first song in the array list when play button is clicked
            currentSongInt = 0;
        }
        //Stops all notifications
        stopForeground(true);

    }

    //Adds 1 to the current song int and plays song will return to 0 if currentSong in is more than the size of songs
    public void next() {
        //New random method to get a random Int
        Random random = new Random();
        repeatSongCheck = currentSongInt;
        //Checking if the shuffle box is checked
        if (shuffle){
            //While loop to get a new number if it matches the current index
            while (currentSongInt == repeatSongCheck) {
                currentSongInt = random.nextInt(3 - 0);
            }
        } else {
            currentSongInt++;
            if (currentSongInt >= songs.size()) {
                currentSongInt = 0;
            }
        }

        playSong();
        createNotification();
    }

    //Subtracts 1 from current song int and plays song, will get the last index of songs array list is the current song is less than 0
    public void previous() {
        //New random method to get a random Int
        Random random = new Random();
        repeatSongCheck = currentSongInt;
        if (shuffle) {
            //While loop to get a new number if it matches the current index
            while (currentSongInt == repeatSongCheck) {
                currentSongInt = random.nextInt(3 - 0);
            }
        }else{
                currentSongInt--;
                if (currentSongInt < 0) {
                    currentSongInt = songs.size() - 1;
                }
            }
        playSong();
        createNotification();
    }

    //Playing song
    public void playSong() {
        //Gets a uri using the directory, filename from array list and the current index;
        uri = Uri.parse(directory+songs.get(currentSongInt).getmUri().toString());
        //If state is preparing returns null
        if (mState == STATE_PREPARING) {
            return;
        }

        //Resets the media play so it can play a new song if needed and sets state to idle;
        mPlayer.reset();
        mState = STATE_IDLE;

        //Setting data source for the media player based on uri
        try {
            mPlayer.setDataSource(this, uri);
            mState = STATE_INITIALIZED;
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Preparing Async and setting state to preparing.
        mPlayer.prepareAsync();
        mState = STATE_PREPARING;
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
    }


    @Override
    public void onPrepared(MediaPlayer mp) {
       //Once media is prepared then the player is started and the Stated is set to started
        mState = STATE_PREPARED;
        mPlayer.start();
        mState = STATE_STARTED;
    }

    //Creating notification is first called to get current song title and artist then it calls startNotification
    public void createNotification(){
        String title = songs.get(currentSongInt).getmTitle();
        String artist = songs.get(currentSongInt).getmArtist();
        startNotification(title, artist);
    }

    //Creates a Notification builder and sets the title as well as the artist.
    public void startNotification(String title, String artist) {
        //Bitmap for Album cover in notification
        Bitmap largeIcon = BitmapFactory.decodeResource(getResources(), songs.get(currentSongInt).getmCover());

        builder = new NotificationCompat.Builder(this);
        builder.setSmallIcon(android.R.drawable.ic_media_play);
        builder.setLargeIcon(largeIcon);
        builder.setContentTitle(title);
        builder.setContentText(artist);
        builder.setAutoCancel(false);
        builder.setOngoing(true);

        //Intent that references the main activity so it can be called when the app isnt running
        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);

        //Pending intent will launch the application if is closed
        PendingIntent pIntent =
                PendingIntent.getActivity(this, REQUEST_NOTIFY_LAUNCH, intent, 0);

        //Setting Pending intent to builder
        builder.setContentIntent(pIntent);

        //Starting notification in foreground
        startForeground(FOREGROUND_NOTIFICATION, builder.build());
    }


}
