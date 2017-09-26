package com.example.stealfast4u.fabflix;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.EditText;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

public class SearchActivity extends AppCompatActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);
        EditText search = (EditText)findViewById(R.id.searchEditText);
    }

    public void search(View view){
        connectToTomcat();
    }

    public void result(String[] movies){
        Intent goToIntent = new Intent(this, MovieListActivity.class);
        goToIntent.putExtra("length", movies.length);

        for(int i = 0; i < movies.length; i++) {
            String index = "movies" + i;
            goToIntent.putExtra(index, movies[i]);
        }
        startActivity(goToIntent);
    }

    public void connectToTomcat(){
        final Map<String, String> params = new HashMap<String, String>();
        Log.d("security", "In the SearchActivity");
        EditText search = (EditText)findViewById(R.id.searchEditText);

        params.put("keyword", search.getText().toString());

        RequestQueue queue = Volley.newRequestQueue(this);

        final Context context = this;
        String url = "http://35.163.34.8:8080/CS122B-Project2/servlet/TomcatFormAndroidSearch";

        StringRequest postRequest = new StringRequest(Request.Method.POST, url,

                new Response.Listener<String>()
                {
                    @Override
                    public void onResponse(String response) {
                     Log.d("security response", response);
                        //String[] movies = response.split("|");
                        StringTokenizer st = new StringTokenizer(response, "|");
                        String[] movies = new String[st.countTokens()];
                        int i = 0;
                        while(st.hasMoreTokens()) {
                            //Log.d("security response", "Result: " + st.nextToken());
                            movies[i++] = st.nextToken();
                        }
                        result(movies);
                    }
                },
                new Response.ErrorListener()
                {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.d("security.error", error.toString());
                    }
                }
        ) {
            @Override
            protected Map<String, String> getParams()
            {
                return params;
            }
        };

        queue.add(postRequest);

        return ;
    }
}
