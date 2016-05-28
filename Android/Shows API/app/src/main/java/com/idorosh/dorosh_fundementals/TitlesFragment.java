package com.idorosh.dorosh_fundementals;

import android.app.FragmentTransaction;
import android.app.ListFragment;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;


public class TitlesFragment extends ListFragment {
    boolean mDualPane;
    int mCurCheckPosition = 0;
    int currentPosition;





    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        //Getting array from xml
        String[] tvShows = getResources().getStringArray(R.array.shows);

        MainActivity main = new MainActivity();


        // Populate list with our static array of shows.
        setListAdapter(new CustomListAdapter(getActivity() , R.layout.custom_list ,tvShows));




        // Check to see if we have a frame in which to embed the details
        // fragment directly in the containing UI.
        View detailsFrame = getActivity().findViewById(R.id.details);
        mDualPane = detailsFrame != null && detailsFrame.getVisibility() == View.VISIBLE;

        if (savedInstanceState != null) {
            // Restore last state for checked position.
            mCurCheckPosition = savedInstanceState.getInt("curChoice", 0);
        }

        if (mDualPane) {
            // In dual-pane mode, the list view highlights the selected item.
            getListView().setChoiceMode(ListView.CHOICE_MODE_SINGLE);
            // Make sure our UI is in the correct state.
            showDetails(mCurCheckPosition);
        }
    }





    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt("curChoice", mCurCheckPosition);
    }





    //Onclick listener to call method show details in current index or get api data based on orientation.
    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        showDetails(position);
        currentPosition = position;
        if (getResources().getConfiguration().orientation
                == Configuration.ORIENTATION_LANDSCAPE) {
            String[] tvShows = getResources().getStringArray(R.array.shows);
            //((MainActivity)getActivity()).listItem(tvShows[position]);
            ((MainActivity)getActivity()).showCurrent(position);
            return;
        }
    }





    //Method that uses the selected index to display a fragment or and activity based on orientation
    void showDetails(int index) {
        mCurCheckPosition = index;


        if (mDualPane) {

            getListView().setItemChecked(index, true);


            // Check what fragment is currently shown, replace if needed.
            DetailsFragment details = (DetailsFragment)

                    getFragmentManager().findFragmentById(R.id.details);
            if (details == null || details.getShownIndex() != index) {
                // Make new fragment to show this selection.
                details = DetailsFragment.newInstance(index);

                //Replacing any existing fragment with this one inside the frame.
                FragmentTransaction ft = getFragmentManager().beginTransaction();
                if (index == 0) {
                    ft.replace(R.id.details, details);
                }
                ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
                ft.commit();
            }

        } else {
            //Launches activity and passes the index through with an intent.
            Intent intent = new Intent();
            intent.setClass(getActivity(), DetailsActivity.class);
            intent.putExtra("index", index);
            startActivity(intent);
        }
    }


}
