/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.rmx.clientapp.Model.Cancelqty;
import com.rmx.clientapp.Model.Order;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.json.simple.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author Supriya Kare
 */
public class CancelQtyDao 
{
    JdbcTemplate template;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }
    
    public List<JSONObject> getCancelData(int serial, String seas_code) {
        return template.query("select style_no,sum(order_qty) as order_qty,buyer_code,delv_date,quota_cat,b_style from order"+seas_code+" where serial='" + serial + "' and cancel is null group by buyer_code,style_no,delv_date,quota_cat,b_style ", new RowMapper<JSONObject>() {
            public JSONObject mapRow(ResultSet rs, int row) throws SQLException {
                Order e = new Order();
                e.setStyle_no(rs.getString(1));
                e.setOrder_qty(rs.getInt(2));
                e.setBuyer_code(rs.getString(3));
                e.setDelv_date(rs.getDate(4));
                e.setQuota_cat(rs.getString(5));
                e.setB_style(rs.getString(6));
                JSONObject data = new JSONObject();
                /* data.add(rs.getString(1));
                 data.add(rs.getInt(2));
                 data.add(rs.getString(3));
                 data.add(rs.getString(4));
                 data.add(rs.getString(5));*/
                //sSystem.out.println("table========"+e);
                data.put("style_no", rs.getString(1));
                data.put("order_qty", rs.getInt(2));
                data.put("buyer_code", rs.getString(3));
                data.put("delv_date", rs.getDate(4));
                data.put("quota_cat", rs.getString(5));
                data.put("b_style", rs.getString(6));

                return data;
            }
        });
    }
    public JSONObject addCancelQty(Cancelqty c)
    {
        String sql=null;
        Date can_date=new Date();
          JSONObject js = new JSONObject();
          String msg;
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        String cancel_date=dt.format(can_date);
        sql="select count(*) from canqty where season='"+c.getSeas_code()+"' and serial= '"+ c.getSerial()+"' ";
        int r=template.queryForObject(sql,Integer.class);
        System.out.println("result ============"+r);
        if(r==0)
        {
            sql="insert into canqty(season,buyer_code,style_no,serial,qty_can,quota_cat,delv_date,can_date) values('"+c.getSeas_code()+"','"+ c.getBuyer_code()+"','"+ c.getStyle_no()+"','"+c.getSerial()+"','"+c.getQty_can()+"','"+c.getQuota_cat()+"','"+c.getDelv_date()+"','"+cancel_date+"')";
            int insres=template.update(sql);
            System.out.println("insert new can qty==========="+insres);
            msg="New record has been created..Requested quantity has been cancelled";
        }
        else
        {
            sql="update canqty set quota_cat='"+c.getQuota_cat()+"' ,delv_date= '"+ c.getDelv_date()+"', qty_can= '"+c.getQty_can()+"' where season='"+c.getSeas_code()+"' and serial= '"+ c.getSerial()+"' ";
            int upres=template.update(sql);
            System.out.println("update result canqty==========="+upres);
            msg="Record has been updated...Requested quantity has been cancelled";

        }
        js.put("msg", msg);
        return js;
    }
}
