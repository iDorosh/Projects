package com.idorosh.i_dorosh_multiactivity;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;




public class DetailViewFragment extends Fragment {

    @Override

    public View onCreateView(LayoutInflater inflater,ViewGroup container, Bundle savedInstanceState) {
        //Inflates the text fragment when text_fragment is set to layout.
        View view = inflater.inflate(R.layout.text_fragment, container, false);
        return view;
    }
}
