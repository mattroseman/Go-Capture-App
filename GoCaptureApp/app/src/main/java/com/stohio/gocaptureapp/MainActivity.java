package com.stohio.gocaptureapp;

import android.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.Gravity;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;
import android.widget.EditText;
import android.provider.MediaStore;
import android.net.Uri;
import android.content.Context;
import android.os.Environment;
import android.provider.MediaStore.Images.Media;
import android.Manifest;
import android.app.Activity;
import android.app.ProgressDialog;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AlertDialog;
import android.content.pm.PackageManager;
import android.content.DialogInterface;
import android.text.InputType;
import android.util.Base64;
import android.content.ActivityNotFoundException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.ByteArrayOutputStream;
import java.util.Map;
import java.util.Hashtable;

import org.json.JSONObject;
import org.json.JSONException;

import com.android.volley.toolbox.StringRequest;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.AuthFailureError;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.RetryPolicy;

public class MainActivity extends AppCompatActivity {

    Button b1;
    ImageView iv;

    private String black_captures, white_captures = "";

    private static final String TAG = "OCVSample::Activity";

    private static final int TAKE_PHOTO_CODE = 1;

    // Storage Permissions
    private static final int REQUEST_EXTERNAL_STORAGE = 1;
    private static String[] PERMISSIONS_STORAGE = {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        verifyStoragePermissions(this);
        setContentView(R.layout.activity_main);

        b1 = (Button)findViewById(R.id.button);
        iv = (ImageView)findViewById(R.id.imageView);

        b1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                takePhoto();
            }
        });
    }

    private void updateButtons() {
        // delete b1
        RelativeLayout main_layout = (RelativeLayout)findViewById(R.id.activity_main);
        // add two buttons, score and upload
        LinearLayout buttons = new LinearLayout(this);
        LayoutParams params = new LinearLayout.LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT);
        buttons.setLayoutParams(params);
        buttons.setOrientation(LinearLayout.HORIZONTAL);

        Button score = new Button(this);
        score.setText("Score");
        score.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                scoreGame();
            }

        });
        Button upload = new Button(this);
        upload.setText("Upload");
        upload.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                uploadImage();
            }

        });

        main_layout.addView(buttons);
        buttons.addView(score);
        buttons.addView(upload);
    }

    private void scoreGame() {
        // create json from image and send to server @score game url
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Title");

        final EditText white_capture_input = new EditText(this);
        white_capture_input.setInputType(InputType.TYPE_CLASS_NUMBER);
        builder.setView(white_capture_input);
        final EditText black_capture_input = new EditText(this);
        black_capture_input.setInputType(InputType.TYPE_CLASS_NUMBER);
        builder.setView(black_capture_input);

        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                white_captures = white_capture_input.getText().toString();
                black_captures = black_capture_input.getText().toString();
            }
        });
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.cancel();
            }
        });

        builder.show();
    }

    private void takePhoto(){
        final Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(getTempFile(this)) );
        startActivityForResult(intent, TAKE_PHOTO_CODE);
    }

    private File getTempFile(Context context){
        //it will return /sdcard/image.tmp
        final File path = new File( Environment.getExternalStorageDirectory(), context.getPackageName() );
        if(!path.exists()){
            path.mkdir();
        }
        return new File(path, "tmp.jpg");
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == RESULT_OK) {
            switch(requestCode){
                case TAKE_PHOTO_CODE:
                    final File file = getTempFile(this);
                    try {
                        Bitmap captureBmp = Media.getBitmap(getContentResolver(), Uri.fromFile(file) );
                        iv.setImageBitmap(captureBmp);
                        iv.invalidate();
                        updateButtons();
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    break;
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    public static void verifyStoragePermissions(Activity activity) {
        // Check if we have write permission
        int permission = ActivityCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE);

        if (permission != PackageManager.PERMISSION_GRANTED) {
            // We don't have permission so prompt the user
            ActivityCompat.requestPermissions(
                    activity,
                    PERMISSIONS_STORAGE,
                    REQUEST_EXTERNAL_STORAGE
            );
        }
    }

    private void uploadImage(){

        JSONObject jo = new JSONObject();
        try {
            jo.put("image", getStringImage(((BitmapDrawable) iv.getDrawable()).getBitmap()));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        //Showing the progress dialog
        final ProgressDialog loading = ProgressDialog.show(this,"Analyzing...","Please wait...",false,false);
        JsonObjectRequest jsonRequest = new JsonObjectRequest(Request.Method.POST, "http://stohio.ngrok.io/api/upload", jo,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        String s = "";
                        //Disimissing the progress dialog
                        loading.dismiss();
                        //Showing toast message of the response
                        try {
                            s = response.getString("status");
                            //s = response.getString("url");
                            String url = response.getString("url");
                            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            intent.setPackage("com.android.chrome");
                            try {
                                startActivity(intent);
                            } catch (ActivityNotFoundException ex) {
                                intent.setPackage(null);
                                startActivity(intent);
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        Toast.makeText(MainActivity.this, s , Toast.LENGTH_LONG).show();
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        //Dismissing the progress dialog
                        loading.dismiss();

                        //Showing toast
                        Toast.makeText(MainActivity.this, volleyError.getMessage().toString(), Toast.LENGTH_LONG).show();
                    }
                }
        );

        jsonRequest.setRetryPolicy(new RetryPolicy() {
            @Override
            public int getCurrentTimeout() {
                return 60000;
            }

            @Override
            public int getCurrentRetryCount() {
                return 50000;
            }

            @Override
            public void retry(VolleyError error) throws VolleyError {

            }
        });

        //Creating a Request Queue
        RequestQueue requestQueue = Volley.newRequestQueue(this);

        //Adding request to the queue
        requestQueue.add(jsonRequest);
    }

    public String getStringImage(Bitmap bmp){
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.JPEG, 100, baos);
        byte[] imageBytes = baos.toByteArray();
        String encodedImage = Base64.encodeToString(imageBytes, Base64.DEFAULT);
        return encodedImage;
    }
}
