/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.rmx.clientapp.Model.Buyer;
import com.rmx.clientapp.Model.Colour;
import com.rmx.clientapp.Model.Season;
import com.rmx.clientapp.Model.Order;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;

public class OrderDao {

    JdbcTemplate template;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    /* public int save(Order o) {
     String sql = "insert into order" + o.getSeas_code() + " (season,serial,buyer_code,style_no,ord_stat,b_style,order_qty,price,currency,wov_hos,INT_ORD,QUOTA_SEG,quota_cat,gar_desc,main_fab,print) "
     + "values('" + o.getSeas_code()+ "','" + o.getSerial()+ "','" + o.getOrd_stat() + "','" + o.getB_style() + "')";
     return template.update(sql);
     }*/
    public int save1(Order o) {
        // System.out.println("oreer========" + o.getSeas_code());

        String sql = "insert into order" + o.getSeas_code() + " (season,serial,ord_stat,b_style) "
                + "values('" + o.getSeas_code() + "','" + o.getSerial() + "','" + o.getOrd_stat() + "','" + o.getB_style() + "')";

        return template.update(sql);
    }

    public int save(Order o) {

        int ctr = 1;
         int res =0;
        String order_date = null;
        String emerg_date = null;
        String delv_date = null;
        Date curr_date = new Date();
        Date deldate = null;
        String time = null;
        String norder_no = null;
        o.setBuyer_code(o.getBuyer_code().toUpperCase());
        System.out.println("Colour List============" + o.getChoices().toString());
        JSONArray colourlist = o.getChoices();
        System.out.println("colourlist size=========" + colourlist.size());
        System.out.println("order date===========" + o.getOrder_date());

        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX");
        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm:ss a");
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");

        order_date = dt.format(o.getOrder_date());
        Calendar cal = Calendar.getInstance();

        String current_date = dt.format(curr_date);
        time = dttime.format(curr_date);
        System.out.println("time=======" + time);
        System.out.println("Todays date========" + current_date);

        //  newdate=(java.util.Date) dt.parse(newdate1);
        System.out.println("order_date==============" + order_date);
        norder_no = "N.A.-" + o.getSerial();
        for (int i = 0; i < colourlist.size(); i++) {
            LinkedHashMap<String, String> obj;
            obj = (LinkedHashMap) colourlist.get(i);
            System.out.println("Delv date====" + obj.get("delv_date"));

            // delv_date=dt.format(obj.get("delv_date"));
            // System.out.println("format date======"+delv_date);
            try {
                deldate = (Date) inputFormat.parse(obj.get("delv_date"));
                System.out.println("parse date========" + deldate);
                delv_date = dt.format(deldate);
                System.out.println("format date=====" + delv_date);
                cal.setTime(deldate);
                cal.add(Calendar.DATE, -15);
                Date emdate = cal.getTime();
                emerg_date = dt.format(emdate);
                System.out.println("emerg_date==========" + emerg_date);
            } catch (ParseException ex) {
                System.out.println(ex);
            }
           // o.setDelv_date((Date)delv_date);

            //System.out.println("Delv date===="+obj.get("delv_date"));
            //  System.out.println("Emergency date========"+emerg_date);
            String sql = "insert into order" + o.getSeas_code() + " (season,serial,ord_stat,b_style,buyer_code,price,currency,colour,order_qty,colour_way,delv_date,quota_cat,int_ord,wov_hos,emb_fl,quota_seg,order_date,p_type,emerg_date,rec_date,time,norder_no,order_no,style_no,fab_con,agent_comm) "
                    + "values('" + o.getSeas_code() + "','" + o.getSerial() + "','" + o.getOrd_stat() + "','" + o.getB_style() + "','" + o.getBuyer_code() + "','" + o.getPrice() + "','" + o.getCurrency() + "','" + obj.get("colour_code") + "','" + obj.get("colour_qty") + "','" + obj.get("colour_way") + "','" + delv_date + "','" + o.getQuota_cat() + "','" + o.getInt_ord() + "','" + o.getWov_hos() + "','" + o.getEmb_fl() + "','" + o.getQuota_seg() + "','" + order_date + "','" + o.getP_type() + "','" + emerg_date + "','" + current_date + "','" + time + "','" + norder_no + "','" + o.getOrder_no().trim() + "','" + o.getStyle_no() + "','" + o.getFab_con() + "','" + o.getAgent_comm() + "')";
            System.out.println("sql======" + sql);
             res = template.update(sql);
            System.out.println("Record inserted=========" + res);
            /*  while (ctr <= colorqnty) {
         
             System.out.println("ctr is inserted========" + ctr);
             ctr++;
         
             }*/
        }
        return res;
    }

    public List<Order> getEmployees() {
        return template.query("select * from order51", new RowMapper<Order>() {
            public Order mapRow(ResultSet rs, int row) throws SQLException {
                
                Order e = new Order();
                e.setSeas_code(rs.getString(1));
                e.setSerial(rs.getInt(2));
                e.setOrd_stat(rs.getInt(3));
                e.setB_style(rs.getString(4));
                //System.out.println("table========"+e);
                return e;
            }
        });
    }

    public List<Season> getAllSeasonsCode() {
        return template.query("select SEAS_CODE from season", new RowMapper<Season>() {
            public Season mapRow(ResultSet rs, int row) throws SQLException {
                Season s = new Season();
                s.setSeas_code(rs.getString(1));
                //s.setSeas_desc(rs.getString(2));  
                //   System.out.println("season========"+rs.getString(1));
                return s;
            }
        });
    }

    public List<Season> getSeasonsCode() {
        return template.query("select SEAS_CODE from season", new RowMapper<Season>() {
            public Season mapRow(ResultSet rs, int row) throws SQLException {
                Season s = new Season();
                s.setSeas_code(rs.getString(1));

                //s.setSeas_desc(rs.getString(2));  
                //   System.out.println("season========"+rs.getString(1));
                return s;
            }
        });
    }

    public String getSeasonsDesc(String seas_code) {
        String sql = "SELECT seas_desc FROM Season WHERE seas_code = ?";
        String seas_desc = (String) template.queryForObject(sql, new Object[]{seas_code}, String.class);
        // System.out.println("seas_desc======="+seas_desc);
        return seas_desc;

    }

    public int getMaxSerial(String seas_code) {
        String sql = "SELECT max(serial) FROM order" + seas_code + " WHERE serial<5000";
        int maxSerial = (int) template.queryForObject(sql, Integer.class);
        maxSerial = maxSerial + 1;
        return maxSerial;
    }

    public List<Buyer> getBuyerCode() {
        return template.query("select buyer_code from buyer where locked is null", new RowMapper<Buyer>() {
            public Buyer mapRow(ResultSet rs, int row) throws SQLException {
                Buyer buyer = new Buyer();
                buyer.setBuyer_code(rs.getString(1));

                //s.setSeas_desc(rs.getString(2));  
                //   System.out.println("season========"+rs.getString(1));
                return buyer;
            }
        });
    }

    public List getStyleNo(String seas_code, String buyer_code) {
        buyer_code = buyer_code.toUpperCase();
        return template.query("select distinct(style_no) from order" + seas_code + " where buyer_code='" + buyer_code + "'", new RowMapper<JSONObject>() {
            public JSONObject mapRow(ResultSet rs, int row) throws SQLException {
                Order od = new Order();
                od.setStyle_no(rs.getString(1));
                JSONObject js = new JSONObject();
                js.put("style_no", rs.getString(1));
           //  System.out.println("styleno==========="+rs.getString(1));       

                //s.setSeas_desc(rs.getString(2));  
                //   System.out.println("season========"+rs.getString(1));
                return js;
            }
        });
    }

    public List getColourData(int colour_code) {
        return template.query("select colour_code,colour_desc from colour where colour_code='" + colour_code + "' ", new RowMapper<Colour>() {
            public Colour mapRow(ResultSet rs, int row) throws SQLException {
                Colour c = new Colour();
                c.setColour_code(rs.getInt("colour_code"));
                c.setColour_desc(rs.getString("colour_desc"));
                JSONObject js = new JSONObject();
                js.put("colour_code", rs.getInt("colour_code"));
                js.put("colour_desc", rs.getString("colour_desc"));
                return c;
            }
        });
    }

    public List getColourList() {
        return template.query("SELECT * FROM COLOUR WHERE FLAG IS NULL order by colour_desc ", new RowMapper<Colour>() {
            public Colour mapRow(ResultSet rs, int row) throws SQLException {
                Colour c = new Colour();
                c.setColour_code(rs.getInt("colour_code"));
                c.setColour_desc(rs.getString("colour_desc"));
                return c;
            }
        });
    }

    public List<JSONObject> getOrderdata(String seas_code, String style_no, String buyer_code) {
        Order od = new Order();
        buyer_code = buyer_code.toUpperCase();
        String sql = "select max(ord_stat) from order" + seas_code + " where CANCEL IS NULL and style_no='" + style_no + "' and buyer_code='" + buyer_code + "' ";
        int ord_stat = template.queryForObject(sql, Integer.class);
        System.out.println("ord_stat========" + ord_stat);
        //  ord_stat = ord_stat + 1;
        //  return  template.query("select * from (select * from order" + seas_code + " where CANCEL IS NULL and style_no='" + style_no + "' and buyer_code='" + buyer_code + "') where rownum=1 ", new RowMapper<JSONObject>() {
        return template.query("select * from order" + seas_code + " where CANCEL IS NULL and style_no='" + style_no + "' and buyer_code='" + buyer_code + "' ", new RowMapper<JSONObject>() {
            public JSONObject mapRow(ResultSet rs, int row) throws SQLException {
                Order od = new Order();
                od.setB_style(rs.getString("b_style"));
                od.setPrice(rs.getFloat("price"));
                od.setCurrency(rs.getString("currency"));
                od.setQuota_seg(rs.getString("quota_seg"));
                od.setQuota_cat(rs.getString("quota_cat"));
                od.setGarment_desc(rs.getString("gar_desc"));
                od.setInt_ord(rs.getString("int_ord"));
                od.setWov_hos(rs.getString("wov_hos"));
                od.setEmb_fl(rs.getString("emb_fl"));
                od.setOrder_no(rs.getString("order_no"));
                od.setMain_fab(rs.getString("main_fab"));
                od.setPrint(rs.getString("print"));
                od.setFab_con(rs.getString("fab_con"));
                od.setComp_code(rs.getInt("comp_code"));
                od.setDyed(rs.getString("dyed"));
                od.setOrder_no(rs.getString("order_no"));
                od.setColour(rs.getInt("colour"));
                JSONObject js = new JSONObject();
                js.put("b_style", rs.getString("b_style"));
                js.put("quota_seg", rs.getString("quota_seg"));
                js.put("price", rs.getFloat("price"));
                js.put("currency", rs.getString("currency"));
                js.put("quota_cat", rs.getString("quota_cat"));
                js.put("gar_desc", rs.getString("gar_desc"));
                js.put("int_ord", rs.getString("int_ord"));
                js.put("wov_hos", rs.getString("wov_hos"));
                js.put("emb_fl", rs.getString("emb_fl"));
                js.put("order_no", rs.getString("order_no"));
                js.put("main_fab", rs.getString("main_fab"));
                js.put("print", rs.getString("print"));
                js.put("fab_con", rs.getString("fab_con"));
                js.put("comp_code", rs.getInt("comp_code"));
                js.put("dyed", rs.getString("dyed"));
                js.put("order_no", rs.getString("order_no"));
                js.put("colour", rs.getInt("colour"));
                List colourdata = getColourData(rs.getInt("colour"));
                js.put("colourdata", colourdata);
                return js;
            }
        });
    }

    public List<JSONObject> getAllEmployees() {
        return template.query("select * from employee", new ResultSetExtractor<List<JSONObject>>() {

            public List<JSONObject> extractData(ResultSet rs) throws SQLException,
                    DataAccessException {

                List<Order> list = new ArrayList<Order>();
                JSONObject js = new JSONObject();
                while (rs.next()) {
                    Order e = new Order();
                    js.put("b_style", rs.getString("b_style"));
                    js.put("quota_seg", rs.getString("quota_seg"));
                    js.put("price", rs.getFloat("price"));
                    js.put("currency", rs.getString("currency"));
                    js.put("quota_cat", rs.getString("quota_cat"));
                    js.put("gar_desc", rs.getString("gar_desc"));
                    js.put("int_ord", rs.getString("int_ord"));
                    js.put("wov_hos", rs.getString("wov_hos"));
                    js.put("emb_fl", rs.getString("emb_fl"));
                    js.put("order_no", rs.getString("order_no"));
                    js.put("main_fab", rs.getString("main_fab"));
                    js.put("print", rs.getString("print"));
                    js.put("fab_con", rs.getString("fab_con"));
                    js.put("comp_code", rs.getInt("comp_code"));
                    js.put("dyed", rs.getString("dyed"));
                    js.put("order_no", rs.getString("order_no"));
                    js.put("colour", rs.getInt("colour"));

                }
                return (List<JSONObject>) js;
            }

        });
    }

    public int getMaxOrd_stat(String seas_code, String style_no, String buyer_code) {
        buyer_code = buyer_code.toUpperCase();
        String sql = "select max(ord_stat) from order" + seas_code + " where CANCEL IS NULL and style_no='" + style_no + "' and buyer_code='" + buyer_code + "' ";
        int ord_stat = template.queryForObject(sql, Integer.class);
        System.out.println("ord_stat========" + ord_stat);
        ord_stat = ord_stat + 1;
        return ord_stat;
    }

    public JSONObject getOrderno(String order_no, String seas_code, String style_no) {
        String res = null;
        String sql = null;
        boolean flag = false;
        final JSONObject js = new JSONObject();
        if (order_no.length() > 0) {
            order_no = order_no.trim();
            System.out.println("order_no==" + order_no);

            sql = "select count(order_no) from order" + seas_code + " where style_no='" + style_no + "' and order_no='" + order_no + "'";
            Integer ordno = template.queryForObject(sql, Integer.class);
            if (ordno > 0) {
                res = order_no + " is already present";
                System.out.println("res====" + res);
                js.put("res", res);
                flag = true;
            } else {
                res = ordno + " is not present";
                flag = false;
                js.put("res", res);
            }
            js.put("flag", flag);
        } else {
            order_no = "N.A.";
            sql = "select order_no from order" + seas_code + " where style_no='" + style_no + "'and order_no like 'N.A.%' ";
            // JSONObject js = new JSONObject();
            return template.query(sql, new ResultSetExtractor<JSONObject>() {

                String neworder_no = null;

                public JSONObject extractData(ResultSet rs) throws SQLException,
                        DataAccessException {
                    ArrayList al = new ArrayList();
                    int str;
                    while (rs.next()) {
                         
                         System.out.println("rs---------"+rs.getString("order_no"));
                        System.out.println("orderno=------------"+rs.getString("order_no").replaceAll("[^0-9]", ""));
                        try
                        {
                         str = Integer.parseInt(rs.getString("order_no").replaceAll("[^0-9]", ""));
                        }
                        catch(Exception e)
                        {str=1;}
                        al.add(str);
                        //System.out.println("str===========" + al);
                        System.out.println("Order_no in database====" + rs.getString("order_no"));

                    }
                    for (int i = 1; i <= 10; i++) {
                        if (al.contains(i)) {

                        } else {
                            neworder_no = "N.A.-" + i;
                            System.out.println("new oorder_no=========" + neworder_no);
                            js.put("order_no", neworder_no);
                            break;
                        }

                    }
                    return js;
                }

            });

        }
        return js;
    }

    public JSONObject getOrderdata1(String seas_code, String style_no, String buyer_code) {
        Order od = new Order();
        buyer_code = buyer_code.toUpperCase();
        return template.query("select * from order" + seas_code + " where CANCEL IS NULL and style_no='" + style_no + "' and buyer_code='" + buyer_code + "' ", new ResultSetExtractor<JSONObject>() {

            public JSONObject extractData(ResultSet rs) throws SQLException,
                    DataAccessException {

                List<Order> list = new ArrayList<Order>();
                JSONObject js = new JSONObject();
                JSONObject colour = new JSONObject();
                ArrayList colourdata = new ArrayList();
                System.out.println("rs==========" + rs.toString());
                while (rs.next()) {
                    js.put("b_style", rs.getString("b_style"));
                    js.put("quota_seg", rs.getString("quota_seg"));
                    js.put("price", rs.getFloat("price"));
                    js.put("currency", rs.getString("currency"));
                    js.put("quota_cat", rs.getString("quota_cat"));
                    js.put("gar_desc", rs.getString("gar_desc"));
                    js.put("int_ord", rs.getString("int_ord"));
                    js.put("wov_hos", rs.getString("wov_hos"));
                    js.put("emb_fl", rs.getString("emb_fl"));
                    js.put("order_no", rs.getString("order_no"));
                    js.put("main_fab", rs.getString("main_fab"));
                    js.put("print", rs.getString("print"));
                    js.put("fab_con", rs.getString("fab_con"));
                    js.put("fab_con2", rs.getString("fab_con2"));
                    js.put("comp_code", rs.getInt("comp_code"));
                    js.put("dyed", rs.getString("dyed"));
                    //  js.put("order_no", rs.getString("order_no"));
                    js.put("colour", rs.getInt("colour"));
                    colourdata.add(getColourData(rs.getInt("colour")));
                  //  System.out.println("colourdata list========"+colourdata.listIterator());
                    // System.out.println("colour========="+rs.getInt("colour"));

                    // System.out.println("json=========="+js.toJSONString());
                }

                colourdata = (ArrayList) colourdata.stream().distinct().collect(Collectors.toList());
                List l3 = new ArrayList(new HashSet(colourdata));
                // System.out.println("l3=======" + l3);
                //  System.out.println("colourdata==========" + colourdata);
                Set aa = new HashSet();
                aa.add("aa");
                aa.add("bb");
                aa.add("aa");
                //  System.out.println("aaaaaaaaaaaa=========" + aa);
                Set hs = new HashSet();
                hs.addAll(colourdata);
                colourdata.clear();
                colourdata.addAll(hs);
                // System.out.println("hash set====colourdata==========" + colourdata);
                js.put("colourdata", colourdata);
                // int ord_stat=getMaxOrd_stat(rs.getString("seas_code"), rs.getString("style_no"), rs.getString("buyer_code"));
                // js.put("ord_stat", ord_stat);
                return js;
            }


            /* Order od = new Order();
             od.setB_style(rs.getString("b_style"));
             od.setPrice(rs.getFloat("price"));
             od.setCurrency(rs.getString("currency"));
             od.setQuota_seg(rs.getString("quota_seg"));
             od.setQuota_cat(rs.getString("quota_cat"));
             od.setGarment_desc(rs.getString("gar_desc"));
             od.setInt_ord(rs.getString("int_ord"));
             od.setWov_hos(rs.getString("wov_hos"));
             od.setEmb_fl(rs.getString("emb_fl"));
             od.setOrder_no(rs.getString("order_no"));
             od.setMain_fab(rs.getString("main_fab"));
             od.setPrint(rs.getString("print"));
             od.setFab_con(rs.getString("fab_con"));
             od.setComp_code(rs.getInt("comp_code"));
             od.setDyed(rs.getString("dyed"));
    
             JSONObject js = new JSONObject();
             js.put("b_style", rs.getString("b_style"));
             js.put("quota_seg", rs.getString("quota_seg"));
             js.put("price", rs.getFloat("price"));
             js.put("currency", rs.getString("currency"));
             js.put("quota_cat", rs.getString("quota_cat"));
             js.put("gar_desc", rs.getString("gar_desc"));
             js.put("int_ord", rs.getString("int_ord"));
             js.put("wov_hos", rs.getString("wov_hos"));
             js.put("emb_fl", rs.getString("emb_fl"));
             js.put("order_no", rs.getString("order_no"));
             js.put("main_fab", rs.getString("main_fab"));
             js.put("print", rs.getString("print"));
             js.put("fab_con", rs.getString("fab_con"));
             js.put("comp_code", rs.getInt("comp_code"));
             js.put("dyed", rs.getString("dyed"));
             //return js;
             return od;*/
        });
    }

    public int getord_stat(String seas_code, String style_no, String buyer_code) {
        Order od = new Order();
        JSONObject js = new JSONObject();
        String sql = "select max(ord_stat) from order" + seas_code + " where CANCEL IS NULL and style_no='" + style_no + "' and buyer_code='" + buyer_code + "' ";
        int ord_stat = template.queryForObject(sql, Integer.class);
        System.out.println("ord_stat========" + ord_stat);
        ord_stat = ord_stat + 1;
        return ord_stat;
    }

    public List getalldata(int serial) {
        return template.query("select style_no,sum(order_qty) as order_qty,buyer_code from order51 where serial='" + serial + "' group by serial,buyer_code,style_no ", new RowMapper() {
            public List mapRow(ResultSet rs, int row) throws SQLException {
                Order e = new Order();
                e.setStyle_no(rs.getString(1));
                e.setOrder_qty(rs.getInt(2));
                e.setBuyer_code(rs.getString(3));
                List data = new ArrayList();
                data.add(rs.getString(1));
                data.add(rs.getInt(2));
                data.add(rs.getString(3));
                //sSystem.out.println("table========"+e);
                return data;
            }
        });

    }

    public List<Order> getalldata1(int serial, String seas_code) {
        //return template.query("select style_no,sum(order_qty) as order_qty,buyer_code,delv_date from sorder"+seas_code+" where serial='" + serial + "' group by serial,buyer_code,style_no,delv_date ",new RowMapper<Order>(){  
        return template.query("select style_no,sum(order_qty) as order_qty,buyer_code,delv_date from order" + seas_code + " where serial='" + serial + "' group by serial,buyer_code,style_no,delv_date ", new RowMapper<Order>() {
            public Order mapRow(ResultSet rs, int row) throws SQLException {
                Order e = new Order();
                e.setStyle_no(rs.getString(1));
                e.setOrder_qty(rs.getInt(2));
                e.setBuyer_code(rs.getString(3));
                e.setDelv_date(rs.getDate(4));
                List data = new ArrayList();
                data.add(rs.getString(1));
                data.add(rs.getInt(2));
                data.add(rs.getString(3));
                //sSystem.out.println("table========"+e);
                return e;
            }
        });

    }

    public List<JSONObject> getCancelData(int serial, String seas_code) {
        return template.query("select style_no,sum(order_qty) as order_qty,buyer_code,delv_date,quota_cat,b_style from order" + seas_code + " where serial='" + serial + "' group by buyer_code,style_no,delv_date,quota_cat,b_style ", new RowMapper<JSONObject>() {
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

    public int updateDelivery_date(int serial, String newdate, String seas_code) {
        String sql = "update order" + seas_code + " set delv_date='" + newdate + "' where serial='" + serial + "'";
        return template.update(sql);
        /*@SuppressWarnings("unchecked")
         public List getAllSeasons() {
         List seasonList = new ArrayList();
         seasonList.add(new Season(1,"India"));
         seasonList.add(new Season(2,"USA"));
         seasonList.add(new Season(3,"UK"));
         return seasonList;
         }*/

    }

    public JSONObject getOrderModdata(String seas_code, int serial) {
        Order od = new Order();
        final JSONObject js = new JSONObject();
        int rc = template.queryForObject("select count(*) from order" + seas_code + " where serial='" + serial + "' ", Integer.class);
        if (rc > 0) {
            return template.query("select * from order" + seas_code + " where serial='" + serial + "' and cancel is null", new ResultSetExtractor<JSONObject>() {

                public JSONObject extractData(ResultSet rs) throws SQLException,
                        DataAccessException {

                    List<Order> list = new ArrayList<Order>();

                    JSONObject colour = new JSONObject();
                    ArrayList colourdata = new ArrayList();
                    int order_qty = 0;
                    System.out.println("rs==========" + rs.toString());
                    while (rs.next()) {
                        order_qty = order_qty + rs.getInt("order_qty");
                        js.put("order_qty", order_qty);
                        js.put("b_style", rs.getString("b_style"));
                        js.put("buyer_code", rs.getString("buyer_code"));
                        js.put("style_no", rs.getString("style_no"));
                        js.put("quota_seg", rs.getString("quota_seg"));
                        js.put("price", rs.getFloat("price"));

                        js.put("quota_cat", rs.getString("quota_cat"));
                        js.put("gar_desc", rs.getString("gar_desc"));

                        js.put("wov_hos", rs.getString("wov_hos"));
                        js.put("emb_fl", rs.getString("emb_fl"));
                        js.put("order_no", rs.getString("order_no"));
                        js.put("main_fab", rs.getString("main_fab"));

                        js.put("fab_con", rs.getString("fab_con"));
                        js.put("fab_con2", rs.getString("fab_con2"));
                        js.put("comp_code", rs.getInt("comp_code"));
                        js.put("dyed", rs.getString("dyed"));
                        js.put("delv_date", rs.getDate("delv_date"));
                        js.put("order_no", rs.getString("order_no"));
                        js.put("assort", rs.getString("assort"));
                        js.put("order_date", rs.getDate("order_date"));
                        js.put("agent_comm", rs.getString("agent_comm"));
                        js.put("quota_grp", rs.getString("quota_grp"));
                        js.put("int_ord", rs.getString("int_ord"));
                        js.put("comm_perc", rs.getInt("comm_perc"));
                        js.put("flag", "true");
                        js.put("colour", rs.getInt("colour"));
                        colourdata.add(getColourData(rs.getInt("colour")));
                    }
                    js.put("colourdata", colourdata);

                    return js;
                }

            });

        } else {
            js.put("msg", "No serial found");
            js.put("flag", "false");
        }
        return js;
    }

    public String saveOrderModify(Order o) {
        System.out.println("data===" + o.getData().toString());
        JSONObject js = new JSONObject(o.getData());
        System.out.println("js==========" + js.get("buyer_code"));
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm:ss a");

        Date curr_date = new Date();
        String m_date = dt.format(curr_date);
        String m_time = dttime.format(curr_date);
        String order_date = dt.format(o.getOrder_date());
        String delv_date = dt.format(o.getDelv_date());
        String updsql = "update order" + o.getSeas_code() + " set b_style='" + o.getB_style() + "',delv_date='" + delv_date + "',quota_seg='" + o.getQuota_seg() + "' ,quota_cat='" + o.getQuota_cat() + "',price='" + o.getPrice() + "',order_date='" + order_date + "',gar_desc='" + o.getGarment_desc() + "',fab_con='" + o.getFab_con() + "',quota_grp='" + o.getQuota_grp() + "',main_fab='" + o.getMain_fab() + "',assort='" + o.getAssort() + "',order_no='" + o.getOrder_no() + "',dyed='" + o.getDyed() + "',agent_comm='" + o.getAgent_comm() + "',comm_perc='" + o.getComm_perc() + "' where serial='" + o.getSerial() + "'";
        int updres = template.update(updsql);
        System.out.println("updres==========" + updres);
        String addnewsql = "insert into ordmod" + o.getSeas_code() + "(serial ,oquota_seg,oquota_cat,oorder_date,oquota_grp,oorder_no,ofab_con,obuyer_style ,ogar_desc ,omain_fab ,oassort_no ,odyed,oprice,nprice,nquota_seg,nquota_cat,norder_date,nquota_grp, nfab_con,nbuyer_style ,ngar_desc,nmain_fab ,nassort_no ,m_date ,m_time,dyed) values('" + o.getSerial() + "','" + js.get("quota_seg") + "','" + js.get("quota_cat") + "','" + js.get("order_date") + "','" + js.get("quota_grp") + "','" + js.get("order_no") + "','" + js.get("fab_con") + "','" + js.get("buyer_style") + "','" + js.get("garment_desc") + "','" + js.get("main_fab") + "','" + js.get("assort_no") + "','" + js.get("dyed") + "','" + js.get("price") + "','" + o.getPrice() + "','" + o.getQuota_seg() + "','" + o.getQuota_cat() + "','" + o.getOrder_date() + "','" + o.getQuota_grp() + "','" + o.getFab_con() + "','" + o.getB_style() + "','" + o.getGarment_desc() + "','" + o.getMain_fab() + "','" + o.getAssort() + "','" + m_date + "','" + m_time + "','" + o.getDyed() + "' )";
        System.out.println("addnewsql=================" + addnewsql);
        //int addnewres = template.update(addnewsql);
        return "updated";
    }

    public List getColours(String seas_code, int serial) {
        String sql = "select colour.colour_code,colour.colour_desc from order" + seas_code + ",colour where serial='" + serial + "' and colour.colour_code= order" + seas_code + ".colour and cancel is null and colour.flag is null ";
        /*  System.out.println("sql===="+sql);
         List colourlist=template.queryForList(sql);
         System.out.println("colourlist========"+colourlist);
         JSONObject js=new JSONObject();
         js.put("colourlist", colourlist);
         return js;*/
        return template.query(sql, new RowMapper<Colour>() {
            public Colour mapRow(ResultSet rs, int row) throws SQLException {
                Colour c = new Colour();
                c.setColour_code(rs.getInt("colour_code"));
                c.setColour_desc(rs.getString("colour_desc"));
                return c;
            }
        });
    }

    public JSONObject getSizePriceData(String seas_code, int serial, int colour_code) {
        String sql = "select * from order" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "' ";
        final String sql2 = "select * from sizeprice" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "'";
        final String sql3 = "select distinct size_type,sum(size_qty) size_qty from size" + seas_code + " where serial='" + serial + "' and colour='" + colour_code + "' and cancel is null group by size_type";
        
       
        
        return template.query(sql, new ResultSetExtractor<JSONObject>() {
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
                List sizedata = template.queryForList(sql2);
                System.out.println("sql2==========" + sql2);
                System.out.println("sizedata======" + sizedata);
                if (!sizedata.isEmpty()) {
                    msg = "Prices Are Already Entered Against This Control No.";
                    js.put("msg", msg);
                    js.put("flag", "false");
                } else {
                    List size = template.queryForList(sql3);
                    System.out.println("size=======" + size);
                    js.put("sizedata", size);
                }
                return js;
            }
        });
    }

    public int saveSizePriceData(Order o) {
        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm:ss a");
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        JSONArray sizepriceArray = o.getSizeprice();
        Date curr_date = new Date();
        String tran_date = dt.format(curr_date);
        String tran_time = dttime.format(curr_date);
        String ipaddress = template.queryForObject("select sys_context('userenv','ip_address') ip from dual", String.class);
        System.out.println("ipaddress=======" + ipaddress);
        String terminal = template.queryForObject(" SELECT SYS_CONTEXT ('USERENV', 'HOST') FROM DUAL ",String.class);
        System.out.println("termianal==========" + terminal);
        terminal=terminal.toUpperCase();
        int res=0;
        for (int i = 0; i < sizepriceArray.size(); i++) {
            LinkedHashMap<String, Object> obj;
            obj = (LinkedHashMap<String, Object>) sizepriceArray.get(i);
            System.out.println("size qty==========" + obj.get("SIZE_QTY"));
            System.out.println("size type ==========" + obj.get("SIZE_TYPE"));
            System.out.println("price ==========" + obj.get("price"));
            String sql = "insert into sizeprice" + o.getSeas_code() + "(serial,style_no,colour,size_type,price,qty,buyer_code,ipaddress,tran_date,tran_time,terminal) values ('" + o.getSerial() + "','" + o.getStyle_no() + "','" + o.getColour() + "','" + obj.get("SIZE_TYPE") + "','" + obj.get("price") + "','" + obj.get("SIZE_QTY") + "','" + o.getBuyer_code() + "','" + ipaddress + "','" + tran_date + "','" + tran_time + "','"+terminal+"') ";
            res = template.update(sql);
            System.out.println("Record inserted res========="+res);
        }
        //  
        return res;
    }
}
