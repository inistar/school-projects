package com.example.stealfast4u.fabflix;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class MovieListActivity extends AppCompatActivity{

    Bundle bundle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_movielist);

        bundle = getIntent().getExtras();
//        if(bundle != null){
//            if(bundle.getString("movies0") != null) {
//
//                Toast.makeText(this, "Movies: " + bundle.get("movies0") + ".", Toast.LENGTH_LONG).show();
//            }
//        }else{
//            Toast.makeText(this, "does not work", Toast.LENGTH_LONG).show();
//        }

        ListView movieList = (ListView) findViewById(R.id.movieList);
        int len = bundle.getInt("length");
        ArrayList<String> currMovies = new ArrayList<String>();

        for(int i = 0 ; i < len; i++){
            String temp = "movies" + i;
            currMovies.add(bundle.getString(temp));
        }

        final ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, currMovies);
        movieList.setAdapter(adapter);

    }
}
