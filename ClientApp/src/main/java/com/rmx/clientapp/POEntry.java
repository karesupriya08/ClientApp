/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.eclipsesource.json.Json;
import com.rmx.clientapp.Model.Colour;
import com.rmx.clientapp.Model.Order;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author Supriya Kare
 */
public class POEntry {

    JdbcTemplate template;
    Order o;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public JSONObject getSizeQtyData(String seas_code, int serial, int colour_code) {
        System.out.println("'===============in size qty================");
        String sql = "select buyer_code from order" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "'";

        final String sql3 = "select distinct size_type,sum(size_qty) size_qty from size" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "' and cancel is null group by size_type";
        String msg = null;
        final JSONObject js = new JSONObject();

        String buyer_code = template.queryForObject(sql, String.class);
        if (!((buyer_code.equals("RDCA")) && (buyer_code.equals("RDPA")) && (buyer_code.equals("CLOK")) && (buyer_code.equals("RDPX")) && (buyer_code.equals("GRCO")) && (buyer_code.equals("GRCD")) && (buyer_code.equals("GRCT")) && (buyer_code.equals("GRCP")) && (buyer_code.equals("GRCC")) && (buyer_code.equals("RDPK")) && (buyer_code.equals("NWTS")))) {
            String sqlord = "select distinct order_no from order" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "'";
            List order_no = template.queryForList(sqlord);
            if (order_no.isEmpty()) {
                msg = "Order Number Not Entered Please Enter Order Number From Order Modification";
                js.put("msg", msg);
                js.put("flag", "false");

            }

        }
        String sql2 = "select count(*) from size" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "'";
        Integer cnt = template.queryForObject(sql2, Integer.class);
        if (cnt != 0) {
            msg = "PO Already Entered";
            js.put("msg", msg);
            js.put("flag", "false");
        } else {

            int res = template.queryForObject("select count(*) from ORDER" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "' and cancel is null", Integer.class);
            if (res == 0) {
                msg = "This Colour Is Cancel Against This Control No.";
                js.put("msg", msg);
                js.put("flag", "false");
            } else {
                String sq = "Select buyer_code,order_no from ORDER" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "' and cancel is null";
                Order ord = (Order) template.queryForObject(sq, new Object[]{}, new BeanPropertyRowMapper(Order.class));
                System.out.println("json-------------" + ord.getBuyer_code());
                System.out.println("json-------------" + ord.getOrder_no());
                String buyer_code1 = ord.getBuyer_code();
                String order_no1 = ord.getOrder_no();
                if (!((buyer_code1.equals("RDCA")) && (buyer_code1.equals("RDPA")) && (buyer_code1.equals("CLOK")) && (buyer_code1.equals("RDPX")) && (buyer_code1.equals("GRCO")) && (buyer_code1.equals("GRCD")) && (buyer_code1.equals("GRCT")) && (buyer_code1.equals("GRCP")) && (buyer_code1.equals("GRCC")) && (buyer_code1.equals("RDPK")) && (buyer_code1.equals("NWTS")))) {
                    if (order_no1.equals("")) {
                        msg = "Please Feed The Order No. From Order Modification Then..........Retry";
                        js.put("msg", msg);
                        js.put("flag", "false");
                    }

                }

            }
            String s = "select * from ORDER" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "'";
            return template.query(s, new ResultSetExtractor<JSONObject>() {
                JSONObject js = new JSONObject();
                String msg = null;

                public JSONObject extractData(ResultSet rs) throws SQLException,
                        DataAccessException {
                    while (rs.next()) {
                        js.put("b_style", rs.getString("b_style"));
                        js.put("buyer_code", rs.getString("buyer_code"));
                        js.put("style_no", rs.getString("style_no"));
                        js.put("colour_way", rs.getString("colour_way"));
                        js.put("gar_desc", rs.getString("gar_desc"));
                        js.put("delv_date", rs.getDate("delv_date"));
                        js.put("wov_hos", rs.getString("wov_hos"));
                        js.put("order_qty", rs.getInt("order_qty"));
                        js.put("main_fab", rs.getString("main_fab"));
                        js.put("print", rs.getString("print"));

                    }
                    return js;
                }

            });
        }
        return js;
    }

    public JSONObject saveSizeQtyPOData(Order o) {
        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm");
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        JSONArray sizeqtyArray = o.getChoices();
        Date curr_date = new Date();
        String m_date_time = dt.format(curr_date);
        String time = dttime.format(curr_date);
        JSONObject js = new JSONObject();
        String msg = null;
        int res = 0;
        String status = "";
        String sizeqtysql = null;
        String size_qty = null, size_type = null;
        String buyer_code = template.queryForObject("select nvl(auto_approved,'N') AA FROM BUYER WHERE BUYER_CODE='" + o.getBuyer_code() + "'", String.class);
        buyer_code = buyer_code.toUpperCase();
        if (buyer_code.equals("Y")) {
            sizeqtysql = "Select count(*) from size" + o.getSeas_code() + " where serial='" + o.getSerial() + "' and colour= '" + o.getColour() + "' ";
            res = template.queryForObject(sizeqtysql, Integer.class);
            if (res > 0) {
                msg = "Already Entered";
                js.put("msg", msg);
            } else {
                for (int i = 0; i < sizeqtyArray.size(); i++) {
                    LinkedHashMap<String, Object> obj;
                    obj = (LinkedHashMap<String, Object>) sizeqtyArray.get(i);
                    System.out.println("size qty==========" + obj.get("size_qty"));
                    System.out.println("size type ==========" + obj.get("size_type"));

                    String insql = "insert into size" + o.getSeas_code() + " (season,serial,style_no,colour,size_type,size_qty,buyer_code,m_date_time,Time,srno) values ('" + o.getSeas_code() + "','" + o.getSerial() + "','" + o.getStyle_no() + "','" + o.getColour() + "','" + obj.get("size_type").toString().toUpperCase() + "','" + obj.get("size_qty") + "','" + o.getBuyer_code() + "','" + m_date_time + "','" + time + "','" + (i + 1) + "')";
                    System.out.println("--------" + insql);
                    int insres = template.update(insql);
                    System.out.println("-----------insres------------" + insres);
                    js.put("msg", "Data Saved....");
                }

            }
        } else {
            sizeqtysql = "Select count(*) from sizechk" + o.getSeas_code() + " where serial='" + o.getSerial() + "' and colour= '" + o.getColour() + "' ";
            res = template.queryForObject(sizeqtysql, Integer.class);
            if (res > 0) {
                msg = "Already Entered";
                js.put("msg", msg);
            } else {

                for (int i = 0; i < sizeqtyArray.size(); i++) {
                    LinkedHashMap<String, Object> obj;
                    obj = (LinkedHashMap<String, Object>) sizeqtyArray.get(i);
                    System.out.println("size qty==========" + obj.get("size_qty"));
                    System.out.println("size type ==========" + obj.get("size_type"));
                    String insql = "insert into sizechk" + o.getSeas_code() + " (season,serial,style_no,colour,size_type,size_qty,buyer_code,m_date_time,Time,srno) values ('" + o.getSeas_code() + "','" + o.getSerial() + "','" + o.getStyle_no() + "','" + o.getColour() + "','" + obj.get("size_type").toString().toUpperCase() + "','" + obj.get("size_qty") + "','" + o.getBuyer_code() + "','" + m_date_time + "','" + time + "','" + (i + 1) + "')";
                    System.out.println("--------" + insql);
                    int insres = template.update(insql);
                    System.out.println("-----------insres------------" + insres);
                    if (buyer_code.equals("N")) {
                        status = "F";
                        int upres = template.update("update sizechk" + o.getSeas_code() + " set status='" + status + "' where serial='" + o.getSerial() + "' and colour= '" + o.getColour() + "'");
                    }
                    js.put("msg", "Data Saved....");
                }

            }
        }

        return js;
    }

    public JSONObject getPOdata(String seas_code, String style_no, String buyer_code) {
        String sql = null;
        JSONObject js = new JSONObject();
        List podata = new ArrayList();
        sql = "SELECT distinct O.SERIAL,O.COLOUR,C.COLOUR_DESC FROM ORDER" + seas_code + " O,COLOUR C,sizechk" + seas_code + " s WHERE O.Serial=s.serial and o.colour=s.colour  AND o.buyer_code=s.buyer_code and o.cancel is null and s.status='F'  and o.colour=c.colour_code AND S.STYLE_NO = '" + style_no + "' AND O.BUYER_CODE = '" + buyer_code + "'";
        System.out.println("sql-------------" + sql);
        List<Map<String, Object>> rec = template.queryForList(sql);
        System.out.println("rec-------------" + rec);
        System.out.println("rec list-----------------" + rec);
        if (!rec.isEmpty()) {
            for (Map row : rec) {
                JSONObject po = new JSONObject();
                po.put("serial", row.get("serial"));
                po.put("colour", row.get("COLOUR"));
                po.put("colour_desc", row.get("colour_desc"));
                System.out.println("po------------" + po);
                podata.add(po);
            }
            js.put("podata", podata);
        } else {
            js.put("poentryflag", "false");
            js.put("msg", "PO Entry unavailable");
        }

        return js;
    }

    public JSONObject getpoorderdata(String seas_code, int serial, int colour) {
        JSONObject podata = new JSONObject();
        String sql = null;
        List podatalist = new ArrayList();
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        String m_date = "";
        sql = "select NVL(ORDER_NO,'N.A.') AA  from ORDER" + seas_code + " where  serial='" + serial + "' and colour='" + colour + "'";
        List<Map<String, Object>> po = template.queryForList(sql);
        if (!po.isEmpty()) {
            for (Map row : po) {
                podata.put("pono", row.get("AA"));
            }
        }
        sql = "select * from sizechk" + seas_code + " where status='F' and serial='" + serial + "' and colour='" + colour + "' order by nvl(srno,0)";
        List<Map<String, Object>> poorderdata = template.queryForList(sql);
        if (!poorderdata.isEmpty()) {
            for (Map row : poorderdata) {
                JSONObject js = new JSONObject();
                js.put("season", row.get("season"));
                js.put("serial", row.get("serial"));
                js.put("colour", row.get("colour"));
                js.put("size_type", row.get("size_type"));
                js.put("size_qty", row.get("size_qty"));
                js.put("style_no", row.get("style_no"));
                js.put("buyer_code", row.get("buyer_code"));
                System.out.println("date----------" + row.get("m_date_time"));
                m_date = dt.format(row.get("m_date_time"));
                js.put("m_date_time", m_date);
                js.put("Time", row.get("Time"));
                js.put("init", row.get("init"));
                podatalist.add(js);
            }
            podata.put("poorderdatalist", podatalist);
        }
        return podata;
    }

    public JSONObject saveApproveddata(JSONObject formdata) {
        System.out.println("formdaaa-------------" + formdata);
        String json = formdata.toString();
        int col, ser,size_qty,i=1;
        String size_type = "", sql = null,init="",buyer_code="",style_no="";
        JSONObject js = new JSONObject();
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm");
        Date curr_date = new Date();
        String todays_date = dt.format(curr_date);
       String time = dttime.format(curr_date);
        
        String seas_code = Json.parse(json).asObject().get("seas_code").asString();
        com.eclipsesource.json.JsonArray items = Json.parse(json).asObject().get("poorderdata").asArray();
        System.out.println("items------------" + items);
        for (com.eclipsesource.json.JsonValue item : items) {
           
            System.out.println("items----------"+items);
            col = item.asObject().getInt("colour", 0);
            ser = item.asObject().getInt("serial", 0);
            size_type = item.asObject().getString("size_type", " ");
            size_qty = item.asObject().getInt("size_qty", 0);
             buyer_code = item.asObject().getString("buyer_code", " ");
             style_no = item.asObject().getString("style_no", " ");
             
            try{
            init=item.asObject().getString("init", " ");}
            catch(Exception e){init="";}
            sql = "update sizechk" + seas_code + " set status='T',appr_date='"+todays_date+"',appr_time='"+time+"',appr_user='"+init+"' where  serial='" + ser + "' and colour='" + col + "' and size_type='" + size_type + "'";
            System.out.println("sql-------------"+sql);
            int upres=template.update(sql);
            System.out.println("upres-------------"+upres);
            sql="select count(*) from size" + seas_code + "  where  serial='"+ser+"' and colour='"+col+"' and size_type='"+size_type+"'";
            System.out.println("sql12================="+sql);
            List li=template.queryForList(sql);
            if(li.size()==-1)
            {
                js.put("msg", "ALREADY ENTERED");
            }
            else
            {
                sql="insert into size" + seas_code + " (season,serial,colour,size_type,size_qty,style_no,buyer_code,m_date_time,Time,init,srno) values ('"+seas_code+"','"+ser+"','"+col+"','"+size_type+"','"+size_qty+"','"+style_no+"','"+buyer_code+"','"+todays_date+"','"+time+"','"+init+"','"+i+"') ";
                 System.out.println("sql===ins================="+sql);
                int insres=template.update(sql);
                 System.out.println("insress================="+insres);
             }
            i++;
        }
        return js;
    }
}
