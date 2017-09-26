package com.example.stealfast4u.fabflix;

//import android.app.DownloadManager;
import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request.Method;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import java.util.HashMap;
import java.util.Map;

public class LoginActivity extends AppCompatActivity {
    Bundle data = new Bundle();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
    }

    public void authenticate(View view){
        connectToTomcat(view);
    }

    public void checkLogin(){
        if(data.getString("login").equals("true\n")) {
            Intent goToIntent = new Intent(this, SearchActivity.class);
            startActivity(goToIntent);
        }else{
            Toast.makeText(this, "Login Failed", Toast.LENGTH_LONG).show();
        }
    }

    public void connectToTomcat(View view){
        final Map<String, String> params = new HashMap<String, String>();

        RequestQueue queue = Volley.newRequestQueue(this);

        EditText username = (EditText)findViewById(R.id.unsernameEditText);
        EditText password = (EditText)findViewById(R.id.passwordEditText);

        params.put("username", username.getText().toString());
        params.put("password", password.getText().toString());

        final Context context = this;
        String url = "http://35.163.34.8:8080/CS122B-Project2/servlet/TomcatFormAndroid";

        StringRequest postRequest = new StringRequest(com.android.volley.Request.Method.POST, url,
                new Response.Listener<String>()
                {
                    @Override
                    public void onResponse(String response) {
                        Log.d("security response", ">>" + response + "<<");
//                        boolean test = response.equals("true\n");
//                        Log.d("security response", Boolean.toString(test));
                        data.putString("login", response);
                        checkLogin();
                    }
                },
                new Response.ErrorListener()
                {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.d("security.error", error.toString());
                        data.putString("login", "false");
                        checkLogin();
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

        return;
    }
}
