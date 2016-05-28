package com.idorosh.i_dorosh_multiactivity;


import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ListViewFragment extends android.app.ListFragment {
    List<Info> arrayList = new ArrayList<>();
    public ArrayAdapter<String> songsAdapter;
    ArrayList<String> songs;
    public static final int NEXT_REQUESTCODE = 1;

    @Override

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        //Inflates the list fragment when it is set to layout
        View view = inflater.inflate(R.layout.list_fragment, container, false);

        //Sets the array list using the read file method in the main activity
        try {
            arrayList = ((MainActivity) getActivity()).readFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //Refresh list gets the titles from the array list
        refreshList();

        //creating a songsAdapter
        songsAdapter = new ArrayAdapter<>(getActivity(),
                android.R.layout.simple_list_item_1, songs);

        //Setting adapter
        setListAdapter(songsAdapter);

        return view;

    }

    //Getting titles from the array list using a for loop
    public void refreshList() {

        songs = new ArrayList<>();

        for (int i = 0; i < arrayList.size(); i++) {
            String title = arrayList.get(i).getmTitle();
            songs.add(title);

        }
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        displayItems(position);
    }

    void displayItems(int index) {


        //Launches activity and passes the index through with an intent.
        Intent intent = new Intent();
        intent.setClass(getActivity(), DetailActivity.class);
        intent.putExtra("currentIndex", index);
        intent.putExtra("songTitle", arrayList.get(index).getmTitle());
        intent.putExtra("songArtist", arrayList.get(index).getmArtist());
        intent.putExtra("songAlbum", arrayList.get(index).getmAlbum());
        startActivityForResult(intent, NEXT_REQUESTCODE);
    }
}