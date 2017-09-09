/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.rmx.clientapp.Model.Order;
import com.rmx.clientapp.Model.Size;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONObject;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 *
 * @author Supriya Kare
 */
public class PrintingDao {

    JdbcTemplate template;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public JSONObject getPrintData(String seas_code, int serial, int colour_code) {
        JSONObject js = new JSONObject();
          Date curr_date = new Date();
          SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
          SimpleDateFormat dttime = new SimpleDateFormat("hh:mm:ss a");
           String current_date = dt.format(curr_date);
       String time = dttime.format(curr_date);
        String sq = "Select b.buyer_code,b_style,style_no,order_qty,gar_desc,main_fab,print,colour_way,ord_stat,c.colour_desc,b.buyer_name from ORDER" + seas_code + ",colour c,buyer b where serial='" + serial + "' and c.colour_code= order" + seas_code + ".colour and b.buyer_code=order"+seas_code+".buyer_code and  colour='" + colour_code + "'";
        List<Map<String, Object>> order = template.queryForList(sq);
        if (!order.isEmpty()) {
            for (Map row : order) {
                js.put("buyer_code", row.get("buyer_code"));
                js.put("style_no", row.get("style_no"));

                js.put("b_style", row.get("b_style"));
                js.put("gar_desc", row.get("gar_desc"));
                js.put("main_fab", row.get("main_fab"));
                js.put("print", row.get("print"));

                js.put("order_qty", row.get("order_qty"));
                js.put("colour_way", row.get("colour_way"));
                js.put("ord_stat", row.get("ord_stat"));
                js.put("colour_desc", row.get("colour_desc"));
                  js.put("buyer_name", row.get("buyer_name"));
            }
        }
        js.put("seas_code", seas_code);
        js.put("serial", serial);
        js.put("colour", colour_code);
        js.put("current_date", current_date);
        js.put("time",time);
                
        String sql = "select size_type,size_qty from size" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "'";
        List size = template.queryForList(sql);

        // js.put("order", order);
        js.put("size", size);
        return js;
    }
}
