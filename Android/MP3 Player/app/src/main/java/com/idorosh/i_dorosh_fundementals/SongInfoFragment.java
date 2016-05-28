/**
 * Created by Ian Dorosh on 10/26/15.
 * MDF 3 1511
 * Week 1 Fundamentals
 */

package com.idorosh.i_dorosh_fundementals;


import android.content.Context;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.ImageView;

public class SongInfoFragment extends Fragment {


    View view;

    //ImageViews are image buttons to control playback
    ImageView playButton;
    ImageView pauseButton;
    ImageView stopButton;
    ImageView nextButton;
    ImageView previousButton;
    CheckBox shuffleBox;


    //Setting view and returning it
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_songsinfo, container, false);
        setOnclickListeners();
        return view;


    }

    //Interface to control media playback by calling methods in main menu which will call methods in the services
    public interface musicControls {
        void play();
        void pause();
        void stop();
        void next();
        void previous();
        void shuffle();
    }

    //Private variable to reference the interface class
    private musicControls song;

    @Override
    public void onAttach(Context context) {

        super.onAttach(context);
        //Reference for musicControls interface
        song = (musicControls) context;
    }


    // Onclick listener for buttons runs method in interface depending on button click
    private View.OnClickListener buttonClicked = new View.OnClickListener() {



        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.playButton){
                song.play();
            }

            if (v.getId() == R.id.pauseButton){
                song.pause();
            }

            if (v.getId() == R.id.stopButton){
                song.stop();
            }

            if (v.getId() == R.id.nextButton){
                song.next();
            }

            if (v.getId() == R.id.previousButton){
                song.previous();
            }

            if (v.getId() == R.id.shuffle){
                song.shuffle();
            }
        }
    };

    //References to the Image Buttons in the songs info fragment
    public void setOnclickListeners(){
        playButton = (ImageView) view.findViewById(R.id.playButton);
        playButton.setOnClickListener(buttonClicked);

        pauseButton = (ImageView) view.findViewById(R.id.pauseButton);
        pauseButton.setOnClickListener(buttonClicked);

        stopButton = (ImageView) view.findViewById(R.id.stopButton);
        stopButton.setOnClickListener(buttonClicked);

        nextButton = (ImageView) view.findViewById(R.id.nextButton);
        nextButton.setOnClickListener(buttonClicked);

        previousButton = (ImageView) view.findViewById(R.id.previousButton);
        previousButton.setOnClickListener(buttonClicked);

        shuffleBox = (CheckBox) view.findViewById(R.id.shuffle);
        shuffleBox.setOnClickListener(buttonClicked);
    }
}
