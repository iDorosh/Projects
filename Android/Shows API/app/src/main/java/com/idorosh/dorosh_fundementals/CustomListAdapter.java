package com.idorosh.dorosh_fundementals;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by iDorosh on 10/6/15.
 */
public class CustomListAdapter extends ArrayAdapter {

    private Context mContext;
    private int id;
    private String[] items;

    public CustomListAdapter(Context context, int textViewResourceId, String[] list) {
        super(context, textViewResourceId, list);
        mContext = context;
        id = textViewResourceId;
        items = list;
    }



    @Override
    public View getView(int position, View v, ViewGroup parent) {
        View mView = v;
        if (mView == null) {
            LayoutInflater vi = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            mView = vi.inflate(id, null);
        }

        TextView text = (TextView) mView.findViewById(R.id.textView23);

        if (items[position] != null) {
            text.setTextColor(Color.WHITE);
            text.setText(items[position]);


        }

        return mView;
    }
}
