package com.idorosh.i_dorosh_multiactivity;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

/**
 * Created by iDorosh on 10/12/15.
 */
public class AddViewFragment extends Fragment {
    @Override

    public View onCreateView(LayoutInflater inflater,ViewGroup container, Bundle savedInstanceState) {

        //Inflates add_fragment
        View view = inflater.inflate(R.layout.add_fragment, container, false);
        return view;

    }
}
