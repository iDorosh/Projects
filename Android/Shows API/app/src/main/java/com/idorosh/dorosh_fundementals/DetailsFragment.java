package com.idorosh.dorosh_fundementals;

import android.app.Fragment;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ScrollView;
import android.widget.TextView;



//NewInstance of the fragment and sends index to display all information under that index
public class DetailsFragment extends Fragment {

    public static DetailsFragment newInstance(int index) {
        DetailsFragment f = new DetailsFragment();

        // Using the index from the new instance parameter as a way to display the correct information.
        Bundle args = new Bundle();
        args.putInt("index", index);
        f.setArguments(args);

        return f;
    }

    //Getting the index
    public int getShownIndex() {
        return getArguments().getInt("index", 0);
    }

}
