/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.eclipsesource.json.Json;
import com.rmx.clientapp.Model.Colour;
import com.rmx.clientapp.Model.Order;
import com.rmx.clientapp.Model.Season;
import com.sun.org.apache.xalan.internal.xsltc.compiler.util.Type;
import com.sun.org.apache.xpath.internal.operations.And;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Session;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.web.bind.annotation.RequestBody;

/**
 *
 * @author Supriya Kare
 */
public class QueryDao {

    JdbcTemplate template;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public List getBuyerCode_List(String seas_code) {
        String sql = "SELECT buyer_name,buyer_code FROM BUYER where buyer_code in (select distinct buyer_code from order" + seas_code + " where cancel is null) order by buyer_code";
        List li = template.queryForList(sql);
        JSONObject js = new JSONObject();
        js.put("buyerlist", li);
        return li;
    }

    public List getStyleNo_List(String seas_code, String buyer_code, String mode) {
        String sampcondi = null;
        System.out.println("mosde=======" + mode);
        if (mode.equals("P".trim())) {

            sampcondi = " serial<7000";
        } else {
            sampcondi = " serial>=7000";
        }
        String sql = "SELECT distinct(style_no) FROM ORDER" + seas_code + " where buyer_code='" + buyer_code + "' cancel is null and  " + sampcondi + " order by style_no";
        List li = template.queryForList(sql);
        JSONObject js = new JSONObject();
        js.put("stylenolist", li);
        return li;
    }

    public List getColourControl_List(String seas_code, String buyer_code, String mode, String style_no) {
        String sampcondi = null;
        System.out.println("mosde=======" + mode);
        if (mode.equals("P".trim())) {

            sampcondi = " serial<7000";
        } else {
            sampcondi = " serial>=7000";
        }
        String sql = "select O.serial,O.colour,O.ord_stat,C.colour_desc,NVL(O.BUY_COL,' ') BUYCOL,nvl(buy_desc,' ') buydesc FROM ORDER" + seas_code + " O,COLOUR C WHERE O.BUYER_CODE='" + buyer_code + "' AND O.STYLE_NO='" + style_no + "' AND O.COLOUR=C.COLOUR_CODE and o.cancel is null and " + sampcondi + " ORDER BY O.SERIAL";
        System.out.println("sql====" + sql);
        List li = template.queryForList(sql);
        JSONObject js = new JSONObject();
        js.put("js", li);
        return li;

        /* return template.query(sql, new RowMapper<JSONObject>() {
         public JSONObject mapRow(ResultSet rs, int row) throws SQLException {
         JSONObject js = new JSONObject();
         js.put("serial", rs.getInt("serial"));
         js.put("colour", rs.getInt("colour"));
         js.put("ord_stat", rs.getInt("ord_stat"));
         js.put("colour_desc", rs.getInt("colour_desc"));
        
        
         return js;
        
         }
         });*/
    }

    public JSONObject getsizeBom_List(String seas_code, int serial, int colour, String mode, String buyer_code) {
        final JSONObject js = new JSONObject();
        String msg = null;
        String sqlrs = null;
        Date curr_date = new Date();
        Date feeddate = null;
        List heading = new ArrayList();
        List<JSONObject> lis = new ArrayList<JSONObject>();
        ArrayList itemcode = new ArrayList();

        SimpleDateFormat dt = new SimpleDateFormat("dd/mm/yyyy");
        String c = dt.format(curr_date);
        try {
            feeddate = dt.parse("10/04/2007");
            curr_date = dt.parse(c);
        } catch (ParseException ex) {
            System.out.println("ParseException===========" + ex);

        }
        String sampcondi = null;
        //System.out.println("mosde=======" + mode);
        if (mode.equals("P".trim())) {

            sampcondi = " serial<7000";
        } else {
            sampcondi = " serial>=7000";
        }

        String sql1 = "SELECT int_ord,B_STYLE,nvl(order_qty,0) order_qty FROM order" + seas_code + " where serial='" + serial + "' and colour='" + colour + "' and cancel is null";
        System.out.println("sql for order qty---------------" + sql1);
        List ord1 = template.queryForList(sql1);
        int oqty = 0;

        for (int i = 0; i < ord1.size(); i++) {
            LinkedHashMap<String, Object> obj;
            obj = (LinkedHashMap) ord1.get(i);
            System.out.println("B_STYLE--------" + obj.get("B_STYLE"));
            js.put("b_style", obj.get("B_STYLE"));
            js.put("order_qty", obj.get("order_qty"));
            System.out.println("order_qty--------" + obj.get("order_qty"));
            oqty = Integer.parseInt(obj.get("order_qty").toString());
        }

        String sqlord = "select distinct style_no,serial,colour,buyer_code from size" + seas_code + " where serial='" + serial + "' minus select style_no,serial,colour,buyer_code from order" + seas_code + " where serial='" + serial + "'";
        List res = template.queryForList(sqlord);
        // System.out.println("res=========" + res);
        if (!res.isEmpty()) {
            msg = "There Is a Problem In This Style,Contact Mis........";
            js.put("msg", msg);

        }
        final int season = Integer.parseInt(seas_code);
        if (season >= 22 && season < 25) {
            sqlrs = "select g.grey_code,g.grey_desc,b.bom_date,b.bom_time,B.QTY,b.catalog,B.SERIAL,b.item_code,b.sizes,b.aveg, b.uom,b.part,b.status,i.fab_desc,i.mfab_desc,c.colour_desc,b.memo_no,b.memo_date from bom" + seas_code + " b, fabric i,colour c,gfabric g   where b.serial='" + serial + "' And ltrim(rtrim(SUBSTR(B.ITEM_CODE, 1, 8))) = LTRIM(RTRIM(I.FAB_CODE)) And TO_NUMBER(SUBSTR(B.ITEM_CODE, 10, 13)) = C.COLOUR_CODE and b.colour='" + colour + "' AND i.grey_code=g.grey_code and I.SEAS'" + seas_code + "'='Y' order by b.bom_date,b.bom_time";
        } else if (season >= 27) {
            if (curr_date.compareTo(feeddate) > 0) {
                // System.out.println("curr date");
                sqlrs = "select serial_no,b.base_code,bf.fab_desc||bf.mfab_desc base_desc,bc.colour_desc bcolour_desc,g.grey_code,g.grey_desc,b.bom_date,b.bom_time,B.QTY,b.catalog,B.SERIAL,b.item_code,b.sizes,b.aveg,b.uom,b.part,b.status,i.fab_desc,i.mfab_desc,c.colour_desc,b.memo_no,b.memo_date,b.appr_date,b.appr_time,nvl(b.imp_flag,'N') impflag from bom" + seas_code + " b, fabric i,colour c,gfabric g,fabric bf,colour bc where b.serial= '" + serial + "' And ltrim(rtrim(SUBSTR(B.ITEM_CODE, 1, 8))) = LTRIM(RTRIM(I.FAB_CODE)) And TO_NUMBER(SUBSTR(B.ITEM_CODE, 10, 13)) = C.COLOUR_CODE And ltrim(rtrim(SUBSTR(B.base_CODE, 1, 8))) = LTRIM(RTRIM(bf.FAB_CODE)) And TO_NUMBER(SUBSTR(B.base_code, 10, 13)) = bc.COLOUR_CODE and b.colour='" + colour + "' AND i.grey_code=g.grey_code and I.SEAS" + seas_code + "='Y' and b." + sampcondi + " order by B.PART,b.serial_no";
            } else {
                // System.out.println("feed date");
                sqlrs = "select b.base_code,bf.fab_desc||bf.mfab_desc base_desc,bc.colour_desc bcolour_desc,g.grey_code,g.grey_desc,b.bom_date,b.bom_time,B.QTY,b.catalog,B.SERIAL,b.item_code,b.sizes,b.aveg,b.uom,b.part,b.status,i.fab_desc,i.mfab_desc,c.colour_desc,b.memo_no,b.memo_date,b.appr_date,b.appr_time,nvl(b.imp_flag,'N') impflag from bom" + seas_code + " b, fabric i,colour c,gfabric g,fabric bf,colour bc where b.serial='" + serial + "' And ltrim(rtrim(SUBSTR(B.ITEM_CODE, 1, 8))) = LTRIM(RTRIM(I.FAB_CODE)) And TO_NUMBER(SUBSTR(B.ITEM_CODE, 10, 13)) = C.COLOUR_CODE And ltrim(rtrim(SUBSTR(B.base_CODE, 1, 8))) = LTRIM(RTRIM(bf.FAB_CODE)) And TO_NUMBER(SUBSTR(B.base_code, 10, 13)) = bc.COLOUR_CODE and b.colour='" + colour + "' AND i.grey_code=g.grey_code and I.SEAS" + seas_code + "='Y' and b." + sampcondi + " order by B.BOM_TIME";
            }
        } else {
            sqlrs = "select b.bom_date,b.bom_time,B.QTY,b.catalog,B.SERIAL,b.item_code,b.sizes,b.aveg, b.uom,b.part,b.status,i.fab_desc,c.colour_desc,b.memo_no,b.memo_date,b.appr_date,b.appr_time from bom" + seas_code + " b, fabric i,colour c  where b.serial='" + serial + "' And ltrim(rtrim(SUBSTR(B.ITEM_CODE, 1, 8))) = LTRIM(RTRIM(I.FAB_CODE)) And TO_NUMBER(SUBSTR(B.ITEM_CODE, 10, 13)) = C.COLOUR_CODE and b.colour='" + colour + "' ";
        }
        //   System.out.println("sqlrs----------" + sqlrs);
        lis = getBomData(sqlrs, season, oqty, itemcode);
        if (!lis.isEmpty()) {
            //  lis.add(getBomData(sqlrs, season, oqty));
            System.out.println("List-------------------" + lis);

        }
        js.put("headings", intializeHeading());
        String rs = "";
        if (curr_date.compareTo(feeddate) > 0) {
            rs = "select to_char(b.bom_date,'mm') a,nvl(ex_flag,' ') ex_flag,b.bom_date,b.bom_time,b.codenum,b.qty,b.catalog,B.SERIAL,b.item_code,b.sizes,b.aveg, b.uom,b.part,b.status,i.fab_desc,c.colour_desc,i.head_code,i.mfab_desc,b.memo_no,b.memo_date,b.appr_date,b.appr_time,nvl(imp_flag,'N') impflag from bom" + seas_code + "  b, NONfab i,colour c  where b.serial='" + serial + "' And LTRIM(RTRIM(SUBSTR(B.ITEM_CODE, 1, 8))) = I.FAB_CODE And TO_NUMBER(SUBSTR(B.ITEM_CODE, 10, 13)) = C.COLOUR_CODE and b.colour='" + colour + "' ORDER BY B.PART,B.SERIAL_NO";
        } else {
            rs = "select nvl(ex_flag,' ') ex_flag,b.bom_date,b.bom_time,b.codenum,b.qty,b.catalog,B.SERIAL,b.item_code,b.sizes,b.aveg, b.uom,b.part,b.status,i.fab_desc,c.colour_desc,i.head_code,i.mfab_desc,b.memo_no,b.memo_date,b.appr_date,b.appr_time,nvl(imp_flag,'N') impflag from bom'" + seas_code + "' b, NONfab i,colour c  where b.serial='" + serial + "' And LTRIM(RTRIM(SUBSTR(B.ITEM_CODE, 1, 8))) = I.FAB_CODE And TO_NUMBER(SUBSTR(B.ITEM_CODE, 10, 13)) = C.COLOUR_CODE and b.colour='" + colour + "' ORDER BY B.PART,b.ITEM_CODE";
        }
        List<Map<String, Object>> lirs = template.queryForList(rs);
        System.out.println("lirs-------------------" + lirs);
        List rs1, rs2;
        String sqrs1 = null, sqrs2 = null;
        String st1 = "", ST2 = "", ST = "", im = "", po = "";
        int pono = 0;

        if (!lirs.isEmpty()) {
            for (Map row : lirs) {
                JSONObject bomdata = new JSONObject();
                sqrs1 = "select po_no from newnonfab.const" + seas_code + " where item_code='" + row.get("item_code") + "' and po_no>0 and raised ='Y' and serial= '" + serial + "' And colour='" + colour + "'";
                try {
                    pono = template.queryForObject(sqrs1, Integer.class);
                } catch (EmptyResultDataAccessException e) {
                    pono = 0;

                }
                /*
                 System.out.println("sqrs1---------------------------" + sqrs1);
                 System.out.println("pono---------------" + pono);*/

                if (pono <= 0) {
                    String q = "select po_no from newnonfab.expobom  where item_code='" + row.get("item_code") + "' and po_no>0  and serial='" + serial + "' And colour='" + colour + "' AND SEASON=" + seas_code;
                    //   System.out.println("sql===========q" + q);
                    try {
                        pono = template.queryForObject(q, Integer.class);
                    } catch (EmptyResultDataAccessException e) {
                        pono = 0;
                    }
                } else {

                    ST2 = " *** ";
                }
                sqrs2 = "select * from imp_detail where item_code='" + row.get("item_code") + "' and serial='" + serial + "' and colour='" + colour + "'  and cancel is null and season='" + seas_code + "'";
                // System.out.println("sqrs2------------------------"+sqrs2);
                rs2 = template.queryForList(sqrs2);
                if (!rs2.isEmpty()) {
                    st1 = " ## ";
                }

                ST = "";
                if (row.get("codenum") != null) {
                    if (Integer.parseInt(row.get("codenum").toString()) == 1) {
                        ST = "*";
                    }
                }
                im = "";
                if (row.get("impflag").toString().equals("Y")) {
                    im = "(I)";
                }
                bomdata.put("item_code", row.get("item_code"));
                bomdata.put("item_desc", ST + row.get("fab_desc") + row.get("mfab_desc") + "");
                bomdata.put("colour", row.get("colour_desc"));
                bomdata.put("size", row.get("sizes"));
                bomdata.put("catalog", row.get("CATALOG"));
                bomdata.put("aveg", row.get("aveg"));
                bomdata.put("uom", row.get("UOM"));
                bomdata.put("part", row.get("PART"));

                if (row.get("STATUS").equals("T")) {
                    bomdata.put("status", "Approved");
                } else {
                    bomdata.put("status", "Not Approved");
                }
                float part = Float.parseFloat(row.get("PART").toString());
                SimpleDateFormat dt1 = new SimpleDateFormat("dd/MM/yyyy");
                String c1 = dt1.format(row.get("bom_date"));
                bomdata.put("bom_date", c1);

                bomdata.put("bom_time", row.get("bom_time"));
                String memo_date = "";//dt.format( row.get("memo_date"));
                try {
                    memo_date = dt.format(row.get("memo_date"));
                } catch (Exception e) {
                    memo_date = "";
                }
                bomdata.put("memo_date", memo_date);
                bomdata.put("memo_no", row.get("memo_no"));
                // String appr_date=dt.format(row.get("appr_date"));
                bomdata.put("appr_date", row.get("appr_date"));

                bomdata.put("appr_time", row.get("appr_time"));
                int part1 = Integer.parseInt(row.get("PART").toString());
                float zz;

                // System.out.println("aveg-------------------"+a);
                if ((part1 == 4) || ((row.get("HEAD_CODE").toString()).equals("ZIPS"))) {
                    if (buyer_code.equals("MACL")) {
                        zz = Math.round((Float.parseFloat(row.get("aveg").toString()) * oqty));
                    } else {
                        zz = Float.parseFloat(row.get("QTY").toString());
                    }
                    String head_code = row.get("HEAD_CODE").toString();
                    if ((head_code.equals("ZIPS"))) {
                        if (zz == 0) {
                            zz = (Float.parseFloat(row.get("aveg").toString())) * oqty;
                        }
                    }
                } else {
                    if ((part1 == 2) || ((row.get("HEAD_CODE").toString()).equals("BUTT"))) {
                        zz = Math.round((Float.parseFloat(row.get("aveg").toString())) * oqty);
                    } else {
                        if ((part1 == 3) && ((row.get("HEAD_CODE").toString()).equals("LABL")) && (buyer_code.equals("NAPJ")) && (row.get("item_code").equals("N/SLB"))) {
                            zz = Math.round((Float.parseFloat(row.get("aveg").toString())) * oqty);
                        } else {
                            zz = (Float.parseFloat(row.get("aveg").toString())) * oqty;
                        }
                    }
                }
                if (zz == 0) {
                    zz = (Float.parseFloat(row.get("aveg").toString())) * oqty;
                }
                bomdata.put("qty", zz);
                String mfab_desc;
                try {
                    mfab_desc = row.get("mfab_desc").toString();
                } catch (NullPointerException e) {
                    mfab_desc = "";
                }

                bomdata.put("item_desc", im + st1 + ST2 + ST + row.get("fab_desc") + mfab_desc + "");
                if (pono == 0) {
                    bomdata.put("pono", "");
                } else {
                    bomdata.put("pono", pono);
                }
                itemcode.add(row.get("item_code"));
                lis.add(bomdata);
            }
            js.put("bomdata", lis);
            js.put("itemcode", itemcode);
        }

        String sql = "select SIZE_TYPE,SIZE_QTY from SIZE" + seas_code + " where serial='" + serial + "' and colour='" + colour + "'  order by nvl(srno,0)";
        List li = template.queryForList(sql);
        js.put("stylenolist", li);
        //  System.out.println("json========" + js);
        return js;

    }

    public List<JSONObject> getBomData(String sqlrs, final int season, final int oqty, ArrayList itemcode) {
        List<JSONObject> al = new ArrayList<JSONObject>();
        String neworder_no = null;
        String im = "";
        SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");

        List<Map<String, Object>> rows = template.queryForList(sqlrs);
        for (Map row : rows) {
            JSONObject bomdata = new JSONObject();
            if (row.get("impflag").equals("Y")) {
                im = "(I)";
            }
            bomdata.put("item_code", row.get("item_code"));
            String mfab_desc;
            try {
                mfab_desc = row.get("mfab_desc").toString();
            } catch (NullPointerException e) {
                mfab_desc = "";
            }

            if (season >= 23) {
                bomdata.put("item_desc", im + row.get("fab_desc") + mfab_desc + "");
            } else {
                bomdata.put("item_desc", row.get("fab_desc"));
            }
            bomdata.put("colour", row.get("colour_desc"));
            bomdata.put("size", row.get("sizes"));
            bomdata.put("catalog", row.get("CATALOG"));
            bomdata.put("aveg", row.get("aveg"));
            bomdata.put("uom", row.get("UOM"));
            bomdata.put("part", row.get("PART"));
            if (row.get("STATUS").equals("T")) {
                bomdata.put("status", "Approved");
            } else {
                bomdata.put("status", "Not Approved");
            }
            float part = Float.parseFloat(row.get("PART").toString());
            if (part == 4) {
                bomdata.put("qty", row.get("QTY"));
            } else {
                float aveg = Float.parseFloat(row.get("aveg").toString());
                bomdata.put("qty", aveg * oqty);
            }
            bomdata.put("grey_code", row.get("grey_code"));
            bomdata.put("grey_desc", row.get("grey_desc"));
            if (season >= 25) {
                bomdata.put("base_code", row.get("base_code"));
                bomdata.put("base_desc", row.get("base_desc"));
                bomdata.put("bcolour_desc", row.get("bcolour_desc"));
            }
            String c = dt.format(row.get("bom_date"));
            bomdata.put("bom_date", c);
            // System.out.println("bomdate----------" + c);
            SimpleDateFormat dt1 = new SimpleDateFormat("dd/MM/yyyy");
            bomdata.put("bom_time", row.get("bom_time"));
            String memo_date = "";//dt.format( row.get("memo_date"));
            try {
                memo_date = dt1.format(row.get("memo_date"));
            } catch (Exception e) {
                memo_date = "";
            }
            bomdata.put("memo_date", memo_date);
            bomdata.put("memo_no", row.get("memo_no"));
            bomdata.put("appr_date", row.get("appr_date"));
            bomdata.put("appr_time", row.get("appr_time"));
            itemcode.add(row.get("item_code"));
            //  System.out.println("bomdata-----------------"+bomdata.toJSONString());
            // jarray.add(bomdata);
            //  System.out.println("jarray-------------------"+jarray);

            al.add(bomdata);
            //  al.add( row.get("item_code"));
        }
        // System.out.println("a1==========" + al);

        /*  return template.query(sqlrs, new RowMapper<JSONObject>() {
        
        
         String neworder_no = null;
         String im = null;
        
         JSONArray libomdata=new JSONArray();
         HashSet<Object> hs=new HashSet<Object>();
         JSONObject bomdata = new JSONObject();
         public JSONObject mapRow(ResultSet rs, int row) throws SQLException {
        
        
         if (rs.getString("impflag").equals("Y")) {
         im = "(I)";
         }
         bomdata.put("item_code", rs.getString("item_code"));
         if (season >= 23) {
         bomdata.put("item_desc", im + rs.getString("fab_desc") + rs.getString("mfab_desc") + " ");
         } else {
         bomdata.put("item_desc", rs.getString("fab_desc"));
         }
         bomdata.put("colour_desc", rs.getString("colour_desc"));
         bomdata.put("sizes", rs.getString("sizes"));
         bomdata.put("Catalog", rs.getString("CATALOG"));
         bomdata.put("aveg", rs.getInt("aveg"));
         bomdata.put("uom", rs.getString("UOM"));
         bomdata.put("part", rs.getInt("PART"));
         if (rs.getString("STATUS").equals("T")) {
         bomdata.put("status", "Approved");
         } else {
         bomdata.put("status", "Not Approved");
         }
         if (rs.getInt("PART") == 4) {
         bomdata.put("qty", rs.getInt("QTY"));
         } else {
         bomdata.put("qty", rs.getInt("aveg") * oqty);
         }
         bomdata.put("grey_code", rs.getString("grey_code"));
         bomdata.put("grey_desc", rs.getString("grey_desc"));
         if (season >= 25) {
         bomdata.put("base_code", rs.getString("base_code"));
         bomdata.put("base_desc", rs.getString("base_desc"));
         bomdata.put("bcolour_desc", rs.getString("bcolour_desc"));
         }
         bomdata.put("bom_date", rs.getDate("bom_date"));
         bomdata.put("bom_time", rs.getString("bom_time"));
         bomdata.put("memo_date", rs.getDate("memo_date"));
         bomdata.put("memo_no", rs.getInt("memo_no"));
         bomdata.put("appr_date", rs.getDate("appr_date"));
         bomdata.put("appr_time",rs.getString("appr_time"));
         System.out.println("js0n-------------"+bomdata.toJSONString());
         libomdata.add(bomdata);
        
         hs.add(bomdata);
        
         System.out.println("hs---------------"+hs.toString());
        
         // js.put("listbomdata", hs);
         return bomdata;
         }
         });*/
        return al;
    }

    public List intializeHeading() {
        List heading = new ArrayList();
        heading.add("Item-Code");
        heading.add("Item-Desc");
        heading.add("Colour");
        heading.add("Size");
        heading.add("Catalog");
        heading.add("Average");
        heading.add("Uom");
        heading.add("Part");
        heading.add("Status");
        heading.add("Quantity");
        heading.add("Grey-Code");
        heading.add("Grey-Desc");
        heading.add("Base-Code");
        heading.add("Base-Desc");
        heading.add("Colour-Desc");
        heading.add("Date");
        heading.add("Time");
        heading.add("Memo Date");
        heading.add("Memo No");
        heading.add("Apprvl.Date");
        heading.add("Apprvl.Time");
        heading.add("Po. No.");
        return heading;
    }

    public JSONObject getFabRate(String seas_code, int serial, int colour, String mode, String buyer_code, String style_no) {
        ArrayList headings = new ArrayList();
        JSONObject js = new JSONObject();
        headings.add("Buyer-Code");
        headings.add("Style-No");
        headings.add("Serial");
        headings.add("Colour");
        headings.add("Fab-Rate");
        headings.add("Hand-Emb");
        headings.add("Mach-Emb");
        headings.add("Aari-Emb.");
        headings.add("Other6");
        headings.add("Other6 Desc");
        headings.add("Others");
        headings.add("Other-Desc");
        headings.add("Others1");
        headings.add("Others1-Desc");
        headings.add("Others2");
        headings.add("Others2-Desc");
        headings.add("Others3");
        headings.add("Others3-Desc");
        headings.add("Others4");
        headings.add("Others4-Desc");
        headings.add("Others5");
        headings.add("Others5-Desc");
        headings.add("Company-Code");
        js.put("headings", headings);
        String sampcondi = null;
        //System.out.println("mosde=======" + mode);
        if (mode.equals("P".trim())) {

            sampcondi = " serial<7000";
        } else {
            sampcondi = " serial>=7000";
        }

        String sql = "select distinct(style_no),serial,colour_desc,comp_code,buyer_Code,nvl(fab_rate,0) fab_rate,nvl(hd_rate,0) hd_rate,nvl(mc_rate,0) mc_rate,nvl(ar_rate,0) ar_rate,nvl(others,0) others,nvl(adda_emb,0) adda_emb,nvl(oth_desc,' ') oth_desc,nvl(oth1,0) oth1,nvl(oth1_desc,' ') oth1_desc,nvl(oth2,0) oth2,nvl(oth2_desc,' ') oth2_desc,nvl(oth4,0) oth4,nvl(oth4_desc,' ') oth4_desc,nvl(oth3,0) oth3,nvl(oth3_desc,' ') oth3_desc, nvl(oth5,0) oth5,nvl(oth5_desc,' ') oth5_desc,nvl(oth6,0) oth6,nvl(oth6_desc,' ') oth6_desc from order" + seas_code + " o,colour c where  cancel is null and colour=c.colour_code and style_no='" + style_no + "' and buyer_code='" + buyer_code + "' and " + sampcondi + " group by comp_code,style_no,fab_rate,hd_rate,mc_rate,ar_rate,buyer_code,others,adda_emb,oth_desc,oth1,oth1_desc,oth2,oth2_desc,oth3,oth3_desc,oth4,oth4_desc,oth5,oth5_desc,OTH6,OTH6_DESC,serial,colour_desc order by buyer_Code,style_no,serial";
        System.out.println("sql----------------------------" + sql);
        List<Map<String, Object>> li = template.queryForList(sql);
        System.out.println("li-------------" + li);
        ArrayList al = new ArrayList();
        for (Map row : li) {
            JSONObject fabdata = new JSONObject();
            fabdata.put("buyer_code", row.get("buyer_code"));
            fabdata.put("style_no", row.get("style_no"));
            fabdata.put("serial", row.get("serial"));
            fabdata.put("colour_desc", row.get("colour_desc"));
            fabdata.put("FAB_RATE", row.get("FAB_RATE"));
            fabdata.put("hd_RATE", row.get("hd_RATE"));
            fabdata.put("MC_RATE", row.get("MC_RATE"));
            fabdata.put("AR_RATE", row.get("AR_RATE"));
            fabdata.put("oth6", row.get("oth6"));
            fabdata.put("oth6_desc", row.get("oth6_desc"));
            fabdata.put("Others", row.get("oth_desc"));
            fabdata.put("oth1", row.get("oth1"));
            fabdata.put("oth1_desc", row.get("oth1_desc"));
            fabdata.put("oth2", row.get("oth2"));
            fabdata.put("oth2_desc", row.get("oth2_desc"));
            fabdata.put("oth3", row.get("oth3"));
            fabdata.put("oth3_desc", row.get("oth3_desc"));
            fabdata.put("oth4", row.get("oth4"));
            fabdata.put("oth4_desc", row.get("oth4_desc"));
            fabdata.put("oth5", row.get("oth5"));
            fabdata.put("oth5_desc", row.get("oth5_desc"));
            fabdata.put("comp_code", row.get("comp_code"));
            System.out.println("fabdata=-------------" + fabdata);
            al.add(fabdata);
        }
        System.out.println("al-------------------" + al);
        js.put("fabdata", al);
        return js;
    }

    public JSONObject getIssueDetail(String seas_code, int serial, int colour, String mode, String buyer_code, String style_no, List itemcode) {
        String BC = "", CB = "", UFLG = "", UNDIS = "";
        String STYR = "", edyr = "";
        String sql = "select * from finyear where cl_flag='Y' and current_flag='Y' order by s_fin_year";
        String sqlyr1 = "select * from finyear where cl_flag='Y' and current_flag='Y'";
        List<Map<String, Object>> yr = template.queryForList(sql);
        List<Map<String, Object>> yr1 = template.queryForList(sqlyr1);
        System.out.println("yr1----------" + yr1);
        if (!yr.isEmpty()) {
            for (Map row : yr) {
                STYR = row.get("STYR").toString();
                edyr = row.get("edyr").toString();
            }
            for (Map row : yr1) {
                System.out.println("yr1-----------------------" + row.get("CURRENT_FLAG"));
                if (row.get("CURRENT_FLAG").equals("Y")) {
                    BC = row.get("STYR").toString();
                    CB = row.get("edyr").toString();
                }
            }
            //LOGIC FOR FABRIC ISSUE/RECEIVING DETAIL  'LIVE TRANSACTION
            for (int k = 1; k <= 3; k++) {
                if (k == 1) {
                    UFLG = "storeb37.";
                    UNDIS = "B-37";
                } else if (k == 2) {
                    UFLG = "storec91.";
                    UNDIS = "GNOIDA";
                } else {
                    UFLG = "yarngn.";
                    UNDIS = "GNOIDA";
                }
                // String sqtran ="select t.ITEM_CODE,t.tran_date,f.fab_desc,c.colour_desc,t.rparty_code,t.avg,t.delv_chal,SUM(t.iss_qty) ISS_QTY,c.colour_code,p.party_name from " + UFLG + "ptran" +STYR+edyr +" t,fabric f,Colour c , "+UFLG+"supplier p where ltrim(rtrim(substr(t.item_code,1,8))) = f.fab_code and to_number(ltrim(rtrim(substr(t.item_code,10,4)))) = c.colour_code and  t.style_no ='"+style_no+"' and t.rparty_code=p.party_code and t.iss_type <> 'RV'  GROUP BY T.ITEM_CODE,T.TRAN_DATE,F.FAB_DESC,c.COLOUR_DESC, T.RPARTY_CODE, T.Avg, T.DELV_CHAL, c.COLOUR_CODE, p.PARTY_NAME";

                String sqtran = "select t.ITEM_CODE,t.tran_date,f.fab_desc,c.colour_desc,t.rparty_code,t.avg,t.delv_chal,SUM(t.iss_qty) ISS_QTY,c.colour_code,p.party_name from " + UFLG + "ptran" + STYR + edyr + " t,fabric f,Colour c  ," + UFLG + "supplier p where ltrim(rtrim(substr(t.item_code,1,8))) = f.fab_code and to_number(ltrim(rtrim(substr(t.item_code,10,4)))) = c.colour_code and  t.style_no = '" + style_no + "' and t.rparty_code=p.party_code and t.iss_type <> 'RV'  GROUP BY T.ITEM_CODE,T.TRAN_DATE,F.FAB_DESC, c.COLOUR_DESC, T.RPARTY_CODE, T.Avg, T.DELV_CHAL, c.COLOUR_CODE, p.PARTY_NAME";
                System.out.println("tranquery---------------------" + sqtran);
                List tran = template.queryForList(sqtran);
                System.out.println("tran--------------" + tran);
            }
        }

        return null;
    }

    public JSONObject getFOC(String seas_code, int serial, int colour, String mode, String buyer_code, String style_no, List itemcode) {

        Date cdt = new Date();
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        String curr_date = dt.format(cdt);
        String squpdate = "";
        List rs2;
        for (int i = 0; i < itemcode.size(); i++) {
            String sql = "select * from bom" + seas_code + " where  (SERIAL,COLOUR) IN  (SELECT SERIAL,COLOUR FROM ORDER" + seas_code + " WHERE STYLE_NO=(SELECT DISTINCT STYLE_NO FROM ORDER" + seas_code + " WHERE serial='" + serial + "' and colour='" + colour + "' AND CANCEL IS NULL))  and status = 'T' and item_code='" + itemcode.get(i) + "' and imp_flag='Y' ";
            //  System.out.println("sql-------------------"+sql);
            //String sql="select * from bom" +seas_code+ " where  (SERIAL,COLOUR) IN  (SELECT SERIAL,COLOUR FROM ORDER" +seas_code+ " WHERE STYLE_NO=(SELECT DISTINCT STYLE_NO FROM ORDER" +seas_code+ " WHERE serial='"+serial+"' and colour='"+colour+"' AND CANCEL IS NULL))  and status = 'T'  and imp_flag='Y' ";
            List<Map<String, Object>> mrs2 = template.queryForList(sql);
            if (!mrs2.isEmpty()) {
                for (Map row : mrs2) {
                    String sqrs3 = "select * from newNONFAB.CONST" + seas_code + " where serial='" + row.get("serial") + "' and colour='" + row.get("colour") + "' and item_code='" + row.get("item_code") + "' and RAISED IS not NULL and po_no>0 ";
                    System.out.println("sqrs3======================" + sqrs3);
                    List rs3 = template.queryForList(sqrs3);
                    System.out.println("rs3------------------" + rs3);
                    if (rs3.isEmpty()) {
                        String sqrs2 = "select * from bom" + seas_code + " where serial='" + serial + "' and colour='" + colour + "' and item_code='" + itemcode.get(i) + "' and status ='T' and imp_flag='Y' and foc_flag is null ";
                        rs2 = template.queryForList(sqrs2);

                        System.out.println("rs2------------------" + rs2);
                        if (!rs2.isEmpty()) {
                            squpdate = "update bom" + seas_code + " set foc_flag='Y',foc_FLAG_DATE= '" + curr_date + "' where serial='" + serial + "' and colour='" + colour + "' and item_code='" + itemcode.get(i) + "' and status ='T' and imp_flag='Y' and foc_flag is null ";
                            int res = template.update(squpdate);
                            System.out.println("update query---------------" + squpdate);
                            System.out.println("res---------------" + res);
                        }
                        sqrs2 = "select * from newNONFAB.CONST" + seas_code + " where serial='" + serial + "' and colour='" + colour + "' and item_code='" + itemcode.get(i) + "' and RAISED IS NULL and imp_flag='Y' and foc_flag is null ";
                        rs2 = template.queryForList(sqrs2);
                        if (!rs2.isEmpty()) {
                            squpdate = "update newNONFAB.CONST" + seas_code + " set foc_flag='Y',foc_FLAG_DATE= '" + curr_date + "' where serial='" + serial + "' and colour='" + colour + "' and item_code='" + itemcode.get(i) + "' and status ='T' and imp_flag='Y' and foc_flag is null ";
                            int res = template.update(squpdate);
                            System.out.println("update query---------------" + squpdate);
                            System.out.println("res---------------" + res);
                        }
                    }
                }
            }
        }
        return null;
    }

    public JSONObject getImport(String seas_code, int serial, int colour, String mode, String buyer_code, String style_no, List itemcode) {
        String sqmrs2 = "", msg = "", sqrs3 = "", sqrs2 = "", squpdate = "", flag = "";
        List<Map<String, Object>> mrs2, rs3, rs2;
        JSONObject js = new JSONObject();
        Date cdt = new Date();
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm:ss a");
        String curr_date = dt.format(cdt);
        String curr_time = dttime.format(cdt);
        for (int i = 0; i < itemcode.size(); i++) {

            if (buyer_code.equals("NAPJ")) {
                sqmrs2 = "select * from bom" + seas_code + " where  (SERIAL,COLOUR) IN (SELECT SERIAL,COLOUR FROM ORDER" + seas_code + " WHERE SERIAL=(SELECT DISTINCT SERIAL  FROM ORDER" + seas_code + " WHERE serial='" + serial + "' and colour='" + colour + "' AND CANCEL IS NULL))  and status = 'T'  and item_code='" + itemcode.get(i) + "'";
                mrs2 = template.queryForList(sqmrs2);
            } else {
                sqmrs2 = "select * from bom" + seas_code + " where  (SERIAL,COLOUR) IN  (SELECT SERIAL,COLOUR FROM ORDER" + seas_code + " WHERE STYLE_NO=(SELECT DISTINCT STYLE_NO FROM ORDER" + seas_code + " WHERE serial='" + serial + "' and colour='" + colour + "' AND CANCEL IS NULL))   and status = 'T'  and item_code='" + itemcode.get(i) + "'";
                mrs2 = template.queryForList(sqmrs2);
            }
            System.out.println("mrs2-------------------" + mrs2);
            if (!mrs2.isEmpty()) {
                for (Map row : mrs2) {
                    if ((row.get("item_code").toString().substring(1, 5)).equals("N/THR")) {
                        msg = "Item  cant be Imported . Pls Contact MIS ";
                        flag = "false";
                        js.put("msg", msg);
                        js.put("flag", flag);
                        break;
                    }
                    sqrs3 = "select * from newNONFAB.CONST" + seas_code + " where serial='" + row.get("serial") + "' and colour='" + row.get("colour") + "' and item_code='" + row.get("item_code") + "' and RAISED IS not NULL and po_no >0 ";
                    rs3 = template.queryForList(sqrs3);
                    System.out.println("rs3----------------" + rs3);
                    if (rs3.isEmpty()) {
                        sqrs2 = "select * from bom" + seas_code + " where serial='" + row.get("serial") + "' and colour='" + row.get("colour") + "'  and item_code='" + row.get("item_code") + "' and status ='T' and imp_flag is null";
                        rs2 = template.queryForList(sqrs2);
                        System.out.println("rs2-------------------" + rs2);
                        if (!rs2.isEmpty()) {
                            squpdate = "update bom" + seas_code + " set imp_flag='Y' ,IMP_FLAG_DATE='" + curr_date + "',imp_flag_time='" + curr_time + "' where serial='" + row.get("serial") + "' and colour='" + row.get("colour") + "'  and item_code='" + row.get("item_code") + "' and status ='T' and imp_flag is null";
                            int res = template.update(squpdate);
                            System.out.println("res------------" + res);
                        }
                        sqrs2 = "select * from newNONFAB.CONST" + seas_code + " where serial='" + row.get("serial") + "' and colour= '" + row.get("colour") + "' and item_code='" + row.get("item_code") + "' and RAISED IS NULL and imp_flag is null";
                        rs2 = template.queryForList(sqrs2);
                        if (!rs2.isEmpty()) {
                            squpdate = "update newNONFAB.CONST" + seas_code + " set imp_flag='Y' ,IMP_FLAG_DATE='" + curr_date + "',imp_flag_time='" + curr_time + "'  where serial='" + row.get("serial") + "' and colour= '" + row.get("colour") + "' and item_code='" + row.get("item_code") + "' and RAISED IS NULL and imp_flag is null";
                            int res = template.update(squpdate);
                            System.out.println("res------------" + res);
                        }
                    }
                }

            }
        }
        return js;
    }

    public List getSerial(String seas_code) {
        String sql = "Select distinct(serial) from ORDER" + seas_code + " where SERIAL NOT BETWEEN  5000 AND 6999 order by serial";
        List serial = template.queryForList(sql);
        return serial;

    }

    public List getColour(String seas_code, int serial) {
        String sql = "SELECT COLOUR.COLOUR_DESC,COLOUR.COLOUR_CODE FROM ORDER" + seas_code + " o, COLOUR WHERE o.SERIAL = '" + serial + "' AND COLOUR.COLOUR_CODE=o.COLOUR and cancel is null AND COLOUR.FLAG IS NULL";
        List colourList = template.queryForList(sql);
        return colourList;

    }

    public JSONObject getBomDetails(String seas_code, int serial, int colour) {
        String sql = "select * from order" + seas_code + " where serial='" + serial + "' and colour='" + colour + "' ";
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
                    js.put("price", rs.getString("price"));
                }
                return js;
            }
        });
    }

    public List getCodeList(String seas_code, String part) {
        String sql = null;
        String a = "Y";
        List codeList = new ArrayList();

        if (part.equals("1")) {
            sql = "SELECT fab_code,fab_desc,mfab_desc FROM FABRIC WHERE SEAS" + seas_code + " ='" + a + "' AND LOCKED IS NULL AND BLOCK IS NULL AND FAB_CODE NOT IN (SELECT LOCK_CODE FROM LOCKCODE)";
            codeList = template.queryForList(sql);
        } else {
            sql = "SELECT fab_code,fab_desc,mfab_desc FROM NONFAB where seas" + seas_code + "='" + a + "'  AND FAB_CODE NOT IN (SELECT LOCK_CODE FROM LOCKCODE)";
            codeList = template.queryForList(sql);
        }
        return codeList;

    }

    public JSONObject getFabGreyCode(String fabcode) {
        String sql = null;
        JSONObject js = new JSONObject();
        sql = "select grey_code from fabric where fab_code='" + fabcode + "'";

        List<Map<String, Object>> grey_codelist = template.queryForList(sql);
        System.out.println("grey_codelist---------" + grey_codelist);

        if (!grey_codelist.isEmpty()) {
            for (Map m : grey_codelist) {
                sql = "";
                sql = "select grey_code,grey_desc from gfabric where grey_code='" + m.get("grey_code") + "'";
                System.out.println("sql======" + sql);
                List<Map<String, Object>> greydata = template.queryForList(sql);
                System.out.println("greydata--------------" + greydata);
                if (!greydata.isEmpty()) {
                    for (Map row : greydata) {
                        js.put("grey_code", row.get("grey_code"));
                        js.put("grey_desc", row.get("grey_desc"));
                    }
                }
            }
        }
        js.put("fabcode", fabcode);
        return js;

    }

    public List getColourList() {
        String sql = null;
        sql = "SELECT colour_code,colour_desc FROM COLOUR WHERE FLAG IS NULL order by colour_desc";
        List colourlist = template.queryForList(sql);
        return colourlist;
    }

    public List getCatalogList() {
        String sql = null;
        sql = "SELECT cat_name FROM CATALOG";
        List cataloglist = template.queryForList(sql);
        return cataloglist;
    }

    public List getUOMList() {
        String sql = null;
        sql = "SELECT UOM FROM CONVERT order by uom";
        List uomlist = template.queryForList(sql);
        return uomlist;
    }

    public List getbasecodelist(String seas_code, String part) {
        String sql = null;
        String a = "Y";
        List basecodelist = new ArrayList();
        sql = "SELECT fab_desc,mfab_desc,fab_code FROM FABRIC WHERE SEAS" + seas_code + "='" + a + "'";
        if (part.equals("1")) {
            basecodelist = template.queryForList(sql);
        }
        return basecodelist;
    }

    public JSONObject checkitemcode(String seas_code, String part, int colour, int serial, String code, String colour_code) {
        String sql = null;
        String ZUZU = null, rep = "", rep1 = "";
        String spacecode = "";
        String spacecolour = "";
        JSONObject js = new JSONObject();
        sql = "SELECT count(*) FROM NONFAB.GMSPO WHERE RTRIM(SUBSTR(ITEM_CODE,1,8))='" + code + "'";
        int cnt = template.queryForObject(sql, Integer.class);
        if (cnt > 0) {
            if (!colour_code.equals("28")) {
                js.put("colourenableflag", "true");
                js.put("msgcolour", "ENTER ONLY STANDARD(28) COLOUR ");

            }
        }
        if (code.length() != 8) {
            int len = 8 - (code.trim().length());
            for (int i = 0; i < len; i++) {
                spacecode = spacecode + " ";
            }
            System.out.println("spacecode len" + spacecode.length());
        }
        if (colour_code.length() != 4) {
            int len = 4 - (colour_code.trim().length());
            for (int i = 0; i < len; i++) {
                spacecolour = spacecolour + " ";
            }
            System.out.println("spacecodecol len" + spacecolour.length());
        }
        sql = "";
        sql = "Select count(*) from Colour where FLAG IS NULL and colour_code='" + colour_code + "'";
        cnt = template.queryForObject(sql, Integer.class);
        if (cnt <= 0) {
            js.put("nocolorfoundflag", "true");
            js.put("nocolourmsg", "No such colour found");
        } else {
            ZUZU = code.trim() + spacecode + "/" + spacecolour + colour_code;
            System.out.println("zuzu=---------------------" + ZUZU);
            List<Map<String, Object>> itemcode;
            sql = "";
            sql = "SELECT ITEM_CODE FROM BOM" + seas_code + " WHERE SERIAL='" + serial + "' AND COLOUR='" + colour + "' AND PART='" + part + "'";
            System.out.println("sql------------" + sql);
            itemcode = template.queryForList(sql);
            System.out.println("itemcode-------------" + itemcode);
            if (!itemcode.isEmpty()) {
                for (Map row : itemcode) {
                    if (row.get("item_code").equals(ZUZU)) {
                        System.out.println("same--");
                        js.put("repeatflag", "true");
                        js.put("msg", "CAN NOT ENTER SAME ITEM CODE WITH SAME COLOUR IN ONE CONTROL NO.");
                        break;
                    }
                }
            }
        }

        return js;
    }

    public JSONObject checkcatalog(String code, String catalog, String part) {
        JSONObject js = new JSONObject();
        String sq = null;
        catalog = catalog.toUpperCase();
        List<Map<String, Object>> catlist;
        if (part.equals("4")) {
            sq = "select HEAD_CODE from nonfab where fab_code='" + code + "'";
            catlist = template.queryForList(sq);
            if (!catlist.isEmpty()) {
                for (Map row : catlist) {
                    if (row.get("HEAD_CODE").equals("CART")) {
                        if (catalog.length() == 0) {
                            js.put("catalogflag", "true");
                            js.put("msg", "In Bom Part 4 Carton Entry.....Can Not Skip Catalog Entry");
                            break;
                        }
                    }
                }
            }
        }
        if (!catalog.equals("")) {
            if (!catalog.equals("N-A")) {
                sq = "SELECT * FROM CATALOG where cat_name='" + catalog + "'";
                catlist = template.queryForList(sq);
                if (catlist.isEmpty()) {
                    js.put("catalogflag", "true");
                    js.put("msg", "CAN NOT FIND THIS CATALOG");
                }
            }
        }
        return js;
    }

    public JSONObject checkFabCode(String fabcode, String part, String seas_code, int colour, int serial, HttpSession session) {
        JSONObject js = new JSONObject();
        fabcode = fabcode.toUpperCase();
        List<Map<String, Object>> li;
        String sq = null;
        String colour_code = "";
        String htype = "";
        sq = "SELECT count(LOCK_CODE) FROM LOCKCODE WHERE LOCK_CODE='" + fabcode + "'";
        int cnt = template.queryForObject(sq, Integer.class);
        if (cnt > 0) {
            js.put("lockcodeflag", "true");
            js.put("msg", "THERE ARE PROBLEM IN THIS CODE...CONTACT MIS");
        }
        sq = "";
        sq = "SELECT HEAD_CODE FROM NONFAB where fab_code='" + fabcode + "' and seas" + seas_code + " ='Y'";
        System.out.println("sq-----------" + sq);
        li = template.queryForList(sq);
        System.out.println("li---------------" + li);
        if (!li.isEmpty()) {
            for (Map row : li) {
                htype = row.get("HEAD_CODE").toString();
            }
        }
        if (part.equals("4")) {
            if (!li.isEmpty()) {
                for (Map row : li) {

                    if (row.get("HEAD_CODE").equals("THRE")) {
                        js.put("colourenableflag", "true");
                    } else {
                        js.put("colour", 28);
                        colour_code = "28";
                        checkitemcode(seas_code, part, colour, serial, fabcode, colour_code);
                        js.put("colourenableflag", "false");
                        js.put("qtyenableflag", "true");
                    }
                }

            }
        } else if (fabcode.equals("N/LBL114")) {
            js.put("itemcodeerroeflag", "true");
            js.put("itemcodemsg", "PLS CHANGE THE CODE INTO N/LBL114.");
        } else if (fabcode.equals("N/STN025")) {
            js.put("itemcodeerroeflag", "true");
            js.put("itemcodemsg", "PLS CHANGE THE CODE INTO N/STN071.");
        } else if (fabcode.equals("N/BUT497")) {
            js.put("itemcodeerroeflag", "true");
            js.put("itemcodemsg", "PLS CHANGE THE CODE INTO N/BUT492.");
        } else {
            js.put("colourenableflag", "true");
            System.out.println("htype---------------" + htype);

        }
        session.setAttribute("htype", htype);
        js.put("htype", htype);

        return js;
    }

    public List getBOMdata(String seas_code, String part, int colour, int serial) {

        List bom = new ArrayList();
        String sq = "";
        sq = "SELECT * FROM BOM" + seas_code + " WHERE SERIAL='" + serial + "' AND COLOUR='" + colour + "' AND PART='" + part + "'";
        List<Map<String, Object>> bomdata = template.queryForList(sq);
        for (Map row : bomdata) {
            JSONObject js = new JSONObject();
            js.put("serial", row.get("serial"));
            js.put("colour", row.get("colour"));
            js.put("item_code", row.get("item_code"));
            js.put("sizes", row.get("sizes"));
            js.put("CATALOG", row.get("CATALOG"));
            js.put("aveg", row.get("aveg"));
            js.put("uom", row.get("uom"));
            bom.add(js);
        }
        return bom;
    }

    public JSONObject saveBomAddNewData(JSONObject data) {
        JSONObject js = new JSONObject();
        Date curr_date = new Date();
        String sq = null;
        String spacecode = "";
        String spacecolour = "";
        String code = data.get("code").toString().trim();
        String colour_code = data.get("colour_code").toString().trim();
        String item_code = null;
        String base_code = null;
        String base_colour = null;
        String htype = data.get("htype").toString();
        if (code.length() != 8) {
            int len = 8 - (code.trim().length());
            for (int i = 0; i < len; i++) {
                spacecode = spacecode + " ";
            }
            System.out.println("spacecode len" + spacecode.length());
        }
        if (colour_code.length() != 4) {
            int len = 4 - (colour_code.trim().length());
            for (int i = 0; i < len; i++) {
                spacecolour = spacecolour + " ";
            }
            System.out.println("spacecodecol len" + spacecolour.length());
        }
        item_code = code + spacecode + "/" + spacecolour + colour_code;
        System.out.println("itemcoe---------------" + item_code);
        String part = data.get("part").toString();
        try {
            base_code = data.get("base_code").toString();
            System.out.println("base_code----------" + base_code);
        } catch (Exception e) {
            base_code = "";
            System.out.println("base_code----------" + base_code);
        }
        try {
            base_colour = data.get("base_colour").toString();
            System.out.println("base_colour----------" + base_colour);
        } catch (Exception e) {
            base_colour = "";
            System.out.println("base_colour----------" + base_colour);
        }
        spacecode = "";
        spacecolour = "";
        if (part.equals("1")) {
            if (base_code.length() != 8) {
                int len = 8 - (base_code.trim().length());
                for (int i = 0; i < len; i++) {
                    spacecode = spacecode + " ";
                }
                System.out.println("spacecode len" + spacecode.length());
            }
            if (base_colour.length() != 4) {
                int len = 4 - (base_colour.trim().length());
                for (int i = 0; i < len; i++) {
                    spacecolour = spacecolour + " ";
                }
                System.out.println("spacecodecol len" + spacecolour.length());
            }
            base_code = base_code + spacecode + "/" + spacecolour + base_colour;
        }
        int qq = 0;
        int qty = 0;
        String qtyfinal = "";
        qtyfinal = data.get("qty").toString();
        //qty=Integer.parseInt(data.get("qty").toString());
        if (!qtyfinal.equals("")) {
            qty = Integer.parseInt(qtyfinal);
            if (part.equals("4")) {
                if (!htype.equals("THRE")) {
                    qq = (int) (qty + (qty * 0.05));
                } else {
                    qq = qty;
                }
            }
            if (htype.equals("ZIPS")) {
                qq = qty;
            }
            if (htype.equals("LABL") && data.get("buyer_code").equals("NAPJ")) {
                qq = qty;
            }
            qtyfinal = "" + qq;
        }

        System.out.println("qty1----------" + qtyfinal);
        sq = "select nvl(auto_approved,'N') AA FROM BUYER WHERE BUYER_CODE='" + data.get("buyer_code") + "'";
        String st = template.queryForObject(sq, String.class);
        String buyer_code = data.get("buyer_code").toString();
        String STATUS = null;
        if (st.equals("Y")) {
            if ((buyer_code.equals("OTHN")) || (buyer_code.equals("OTWW")) || (buyer_code.equals("OTZY")) && code.equals("N/LBL082")) {
                STATUS = "F";
            } else {
                STATUS = "T";
            }
        } else {
            STATUS = "F";
        }
        System.out.println("status-------------" + STATUS);
        sq = "";
        sq = "SELECT conV_fac FROM CONVERT WHERE uom='" + data.get("uom") + "'";
        List<Map<String, Object>> con = template.queryForList(sq);
        String conV_fac = null;
        for (Map row : con) {
            conV_fac = row.get("conV_fac").toString();
        }
        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm:ss a");
        String today_date = dt.format(curr_date);
        String today_time = dttime.format(curr_date);
        String codenum = "";
        if (htype.equals("ZIPS")) {
            codenum = "1";
        }

        sq = "";
        sq = "insert into bom" + data.get("seas_code") + " (season,serial,colour,item_code,sizes,catalog,aveg,uom,base_code,qty,status,conV_fac,part,bom_date,bom_time,codenum) values ('" + data.get("seas_code") + "','" + data.get("serial") + "','" + data.get("colour") + "','" + item_code + "','" + data.get("width") + "','" + data.get("catalog") + "','" + data.get("avg") + "','" + data.get("uom") + "','" + base_code + "','" + qtyfinal + "','" + STATUS + "','" + conV_fac + "','" + part + "','" + today_date + "','" + today_time + "','" + codenum + "')";
        int resaddnew = template.update(sq);
        System.out.println("sq---------" + sq);
        System.out.println("resadd------------" + resaddnew);
        System.out.println("");
        js.put("msg", "New Record inserted---------");
        if (st.equals("Y")) {
            STATUS = "T";
        } else {
            STATUS = "F";
        }
        sq = "";
        sq = "insert into CHBOM" + data.get("seas_code") + " (season,serial,colour,item_code,sizes,catalog,aveg,uom,base_code,qty,status,conV_fac,part,b_date_time,Time) values ('" + data.get("seas_code") + "','" + data.get("serial") + "','" + data.get("colour") + "','" + item_code + "','" + data.get("width") + "','" + data.get("catalog") + "','" + data.get("avg") + "','" + data.get("uom") + "','" + base_code + "','" + qtyfinal + "','" + STATUS + "','" + conV_fac + "','" + part + "','" + today_date + "','" + today_time + "')";
        System.out.println("sq=======chbom-------" + sq);
        resaddnew = template.update(sq);
        System.out.println("resadd------------" + resaddnew);
        return js;

    }

    public JSONObject getBOMCopydata(String seas_code, String part, int colour, int serial) {

        List al = new ArrayList();
        JSONObject j = new JSONObject();
        String sq = null, sqord = null;
        String bcode = null;
        sqord = "SELECT BUYER_CODE,style_no FROM ORDER" + seas_code + " WHERE SERIAL='" + serial + "' AND COLOUR='" + colour + "'";
        List<Map<String, Object>> ord = template.queryForList(sqord);

        sq = "SELECT * FROM BOM" + seas_code + " WHERE SERIAL='" + serial + "' AND COLOUR='" + colour + "' AND PART='" + part + "' ORDER BY BOM_DATE,ITEM_CODE";
        List<Map<String, Object>> bomdata = template.queryForList(sq);
        if (!bomdata.isEmpty()) {
            for (Map row : ord) {
                bcode = row.get("buyer_code").toString();
                j.put("style_no", row.get("style_no"));
            }
            //al.add(j);
            for (Map row : bomdata) {
                JSONObject bomdatajs = new JSONObject();
                bomdatajs.put("serial", row.get("serial"));
                bomdatajs.put("colour", row.get("colour"));
                bomdatajs.put("item_code", row.get("item_code"));
                bomdatajs.put("sizes", row.get("sizes"));
                bomdatajs.put("aveg", row.get("aveg"));
                bomdatajs.put("part", row.get("part"));
                bomdatajs.put("base_code", row.get("base_code"));
                al.add(bomdatajs);

            }
            j.put("bomdata", al);
            sq = "";
            if (!bcode.equals("RDPA") && !bcode.equals("RDPX")) {
                sq = "select o.serial,o.colour,c.colour_desc,o.STYLE_NO from order" + seas_code + " O,COLOUR C  where  O.COLOUR=C.COLOUR_CODE AND O.BUYER_CODE='" + bcode + "' and NOT(o.serial ='" + serial + "' AND  o.colour='" + colour + "') AND CANCEL IS NULL ORDER BY SERIAL";
            } else {
                sq = "SELECT O.SERIAL,O.COLOUR,C.COLOUR_DESC,O.style_no FROM ORDER" + seas_code + " O,COLOUR C  where  O.COLOUR=C.COLOUR_CODE AND O.BUYER_CODE IN('" + bcode + "','SEIA','RDCA','DESH','NWTS') and NOT(o.serial ='" + serial + "' AND  o.colour='" + colour + "') AND CANCEL IS NULL ORDER BY SERIAL";
            }
            System.out.println("sq------------" + sq);
            List<Map<String, Object>> seriallist = null;
            seriallist = template.queryForList(sq);
            List alserial = new ArrayList();
            System.out.println("serriallist----------" + seriallist);
            if (!seriallist.isEmpty()) {
                for (Map row : seriallist) {
                    JSONObject seriallistjs = new JSONObject();
                    seriallistjs.put("serial", row.get("serial"));
                    seriallistjs.put("colour", row.get("colour"));
                    seriallistjs.put("style_no", row.get("style_no"));

                    seriallistjs.put("colour_desc", row.get("colour_desc"));
                    alserial.add(seriallistjs);

                }
                j.put("seriallist", alserial);
            }
        } else {
            j.put("nodataflag", "true");
            j.put("msg", "NO BOM FOUND FOR GIVEN CONTROL NO.");
            System.out.println("no data found ");
        }
        return j;
    }

    public List getColourListAll() {
        String sq = "SELECT * FROM COLOUR order by colour_desc";
        List al = template.queryForList(sq);
        return al;
    }

    public JSONObject saveCopyData(JSONObject formdata) {
        JSONObject js = new JSONObject();
        String seas_code = null;
        int zz = 0;
        System.out.println("savecopy data======================");
        int col, bcol, bser;//= Json.parse(json).asObject().getInt("colour", 0);
        int ser, colour, part;
        float aveg = 0;
        String serial;
        String item_code = null, bitem_code;
        int ord = 0;
        boolean present = false;
        String base_code = null, bbase_code = "", obase_code = "";
        String sizes = "", catalog = "", conV_fac = "", uom = "";
        String sqcp, sqfb, sqmrec = null, sqins = null;
        String meditem_code = null, codenum = "";
        String Type = "";
        String base_code1 = "";
        String json = formdata.toString();
        String BCODE = "", status = "";
        String todays_date = "";
        String time = "", COPY_FLAG = "";
        String buyer = "";
        String qty = "";
        System.out.println("json------------" + json);
        seas_code = Json.parse(json).asObject().get("seas_code").asString();
        //System.out.println("seas_coe==============="+seas_code);
        serial = Json.parse(json).asObject().get("serial").asString();
        // System.out.println("seas_coe==============="+serial);
        colour = Json.parse(json).asObject().get("colour").asInt();
        // System.out.println("seas_coe==============="+colour);
        System.out.println("colour----------" + colour);
        List<Map<String, Object>> li = template.queryForList("SELECT BUYER_CODE FROM ORDER" + seas_code + " WHERE SERIAL='" + serial + "' and COLOUR='" + colour + "'");
        for (Map m : li) {
            BCODE = m.get("BUYER_CODE").toString();
        }
        part = Integer.parseInt(Json.parse(json).asObject().get("part").asString());
        com.eclipsesource.json.JsonArray items = Json.parse(json).asObject().get("selItemColorArray").asArray();
        System.out.println("items------------" + items);
        for (com.eclipsesource.json.JsonValue item : items) {
            col = item.asObject().getInt("colour", 0);
            ser = item.asObject().getInt("serial", 0);
            System.out.println("ser------------" + ser);
            item_code = item.asObject().getString("item_code", "");
            System.out.println("item_code------------" + item_code);
            try {
                base_code1 = item.asObject().getString("base_code", " ");
            } catch (Exception e) {
                base_code1 = "";
            }
            System.out.println("base_code1------------" + base_code1);
            String sqchk = "select item_code from bOM" + seas_code + " where serial='" + ser + "' and colour='" + col + "'";
            System.out.println("sqdel resuly temp invoice--------" + sqchk);
            List<Map<String, Object>> chk = template.queryForList(sqchk);
            System.out.println("list=============" + chk);
            List<Map<String, Object>> liord = template.queryForList("select sum(order_qty) oqty from order" + seas_code + " where serial='" + ser + "' and colour='" + col + "'");
            System.out.println("ord-----------------" + liord);
            for (Map or : liord) {
                ord = Integer.parseInt(or.get("oqty").toString());
            }
            present = false;
            if (!chk.isEmpty()) {
                for (Map row : chk) {
                    if (item_code.equals(row.get("item_code"))) {
                        System.out.println("present=true===--------------");
                        present = true;
                        js.put("msg", "Record is already present");

                    }
                }
            }
            if (present == false) {
                System.out.println("present=false-----------");
                int bompart = 0;
                sqcp = "SELECT * FROM BOM" + seas_code + " WHERE SERIAL='" + serial + "' AND COLOUR='" + colour + "' and item_code='" + base_code1 + "'";
                System.out.println("cp sql---------------------" + sqcp);
                List<Map<String, Object>> cp = template.queryForList(sqcp);
                meditem_code = item_code.substring(0, 8);
                System.out.println("meditem_code-----------" + meditem_code);
                sqfb = "SELECT * FROM NONFAB WHERE FAB_CODE='" + meditem_code + "'";
                System.out.println("sqfb----------------" + sqfb);
                List<Map<String, Object>> fb = template.queryForList(sqfb);
                System.out.println("med------------" + fb);
                sqmrec = "SELECT * FROM BOM" + seas_code + " WHERE SERIAL='" + ser + "' AND COLOUR='" + col + "' AND ITEM_CODE='" + item_code + "'";
                List mrec = template.queryForList(sqmrec);
                System.out.println("mrec-------------" + mrec);
                if (mrec.isEmpty()) {
                    if (!fb.isEmpty()) {
                        for (Map row : fb) {
                            if (row.get("HEAD_CODE").equals("ZIPS")) {
                                codenum = "1";
                            }
                        }
                    }
                    System.out.println("cp==========" + cp);
                    for (Map c : cp) {
                        bompart = Integer.parseInt(c.get("part").toString());
                        System.out.println("bompart-----------" + c.get("PART"));
                        if (bompart == 1) {
                            System.out.println("1============");
                            com.eclipsesource.json.JsonArray bcodeitems = Json.parse(json).asObject().get("selBaseColorArray").asArray();
                            for (com.eclipsesource.json.JsonValue bitem : bcodeitems) {
                                bcol = bitem.asObject().getInt("colour", 0);
                                bser = bitem.asObject().getInt("serial", 0);
                                base_code = bitem.asObject().getString("base_code", "");
                                obase_code = bitem.asObject().getString("obase_code", "");
                                bitem_code = bitem.asObject().getString("item_code", "");
                                if (bcol == col && bser == ser && (obase_code.equals(c.get("base_code")) && (bitem_code.equals(c.get("item_code"))))) {
                                    bbase_code = bitem.asObject().getString("base_code", "");
                                    System.out.println("bbase_code----------" + bbase_code);
                                }
                            }
                        }
                        sizes = c.get("sizes").toString();
                        System.out.println("sizes-----------" + sizes);
                        catalog = c.get("catalog").toString();
                        System.out.println("catalog------------" + catalog);
                        if (!c.get("conV_fac").equals("")) {
                            conV_fac = c.get("conV_fac").toString();
                            System.out.println("conV_fac------------" + conV_fac);
                        }
                        aveg = Float.parseFloat(c.get("aveg").toString());
                        System.out.println("aveg------------" + aveg);
                        uom = c.get("uom").toString();
                        System.out.println("uon------------" + uom);

                        if (part == 4) {
                            zz = (int) ((ord * aveg) + ((ord * aveg) * 0.05));
                            if (zz < 1) {
                                zz = 1;
                                qty = "" + zz;
                            }
                        }
                        System.out.println("itemcode===========mid-====" + item_code.substring(0, 4));
                        if (item_code.substring(0, 3).equals("N/ZI")) {
                            zz = (int) (ord * aveg);
                            if (zz < 1) {
                                zz = 1;
                                qty = "" + zz;
                            }
                        }
                        System.out.println("zz-----------" + zz);
                        System.out.println("qty-----" + qty);

                        buyer = template.queryForObject("select nvl(auto_approved,'N') AA FROM BUYER WHERE BUYER_CODE='" + BCODE + "'", String.class);
                        System.out.println("buyer------------" + buyer);
                        if (BCODE.equals("OTHN") || BCODE.equals("OTZY") || BCODE.equals("OTWW") && item_code.substring(0, 8).equals("N/LBL082")) {
                            status = "F";
                        } else {
                            if (buyer.equals("Y")) {
                                status = "T";
                            } else {
                                status = "F";
                            }
                        }
                        System.out.println("statsu--------------" + status);
                        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
                        SimpleDateFormat dttime = new SimpleDateFormat("hh:mm:ss a");
                        Date curr_date = new Date();
                        todays_date = dt.format(curr_date);
                        time = dttime.format(curr_date);
                        COPY_FLAG = "Y";
                        System.out.println("item_code-----------------" + item_code);
                        sqins = "insert into bom" + seas_code + " (season,serial,colour,item_code,codenum,sizes,catalog,conV_fac,aveg,uom,part,qty,status,bom_date,bom_time,COPY_FLAG,base_code) values ('" + seas_code + "','" + ser + "','" + col + "','" + item_code + "','" + codenum + "','" + sizes + "','" + catalog + "','" + conV_fac + "','" + aveg + "','" + uom + "','" + bompart + "','" + qty + "','" + status + "','" + todays_date + "','" + time + "','" + COPY_FLAG + "','" + bbase_code + "') ";
                        int insres = template.update(sqins);
                        System.out.println("sqins===========" + sqins);
                        System.out.println("insres===========" + insres);
                        if (bompart == 1) {
                            bbase_code = c.get("base_code").toString();
                        }
                        if (part == 4) {
                            zz = (int) ((ord * aveg) + ((ord * aveg) * 0.05));
                            if (zz < 1) {
                                zz = 1;
                                qty = "" + zz;
                            }
                        }
                        if (buyer.equals("Y")) {
                            status = "T";
                        } else {
                            status = "F";
                        }
                        Type = "A";
                        String sqch = "insert into CHBOM" + seas_code + " (season,serial,colour,item_code,sizes,catalog,conV_fac,aveg,uom,part,qty,status,b_date_time,Time,TYPE,base_code) values ('" + seas_code + "','" + ser + "','" + col + "','" + item_code + "','" + sizes + "','" + catalog + "','" + conV_fac + "','" + aveg + "','" + uom + "','" + bompart + "','" + qty + "','" + status + "','" + todays_date + "','" + time + "','" + Type + "','" + bbase_code + "') ";
                        System.out.println("sqch-----------" + sqch);
                        int chres = template.update(sqch);

                        if (insres > 1 && chres > 1) {
                            js.put("msg", "Record is already present");
                        }
                    }
                }
            }
        }
        return js;
    }

    public JSONObject getBomappdata(String seas_code, String style_no, String buyer_code, String fabradio) {
        JSONObject js = new JSONObject();
        System.out.println("fabradio-------------" + fabradio);
        if (fabradio.equals("true")) {

        } else {

        }
        return js;

    }

    public List getCodeListforBom4(String seas_code) {
        String sql = null;
        String a = "Y";
        List codeList = new ArrayList();
        sql = "SELECT fab_desc,mfab_desc,fab_code FROM NONFAB where seas" + seas_code + "='Y' and head_code in ('TAGS','CARD','CART','POLY','SHET','STIK','THRE','FOAM','SEET','LABL','ACCS','HANG') order by fab_code";
        codeList = template.queryForList(sql);

        return codeList;

    }

    public List getStyleNoListBOM4(String seas_code, String buyer_code) {
        String sql = "SELECT distinct(style_no) FROM ORDER" + seas_code + " where buyer_code='" + buyer_code + "' and cancel is null order by style_no";
        List li = template.queryForList(sql);

        return li;
    }

    public JSONObject checkItemCodeBOM4(String item_code, String seas_code) {
        JSONObject js = new JSONObject();
        item_code=item_code.toUpperCase();
        
        if (item_code.equals("N/CAR095")) {
              js.put("changeitemcodeflag", "true");
            js.put("changeitemcodeflagmsg", "Can not enter this code. Enter 'N/CAR016' instaed of this code.");
           return js;
         
        } else if (item_code.equals("N/PBG792")) {
              js.put("changeitemcodeflag", "true");
            js.put("msg", "Can not enter this code. Enter  'N/PBG733' instaed of this code.");
             return js;
        } else if (item_code.equals("N/THR042")) {
              js.put("changeitemcodeflag", "true");
            js.put("msg", "Can not enter this code. Enter 'N/THR009' instaed of this code.");
             return js;
        }
        String sql = null;
        sql = "SELECT HEAD_CODE FROM NONFAB where fab_code='" + item_code.trim() + "' and seas" + seas_code + "='Y' and (head_code in ('TAGS','CARD','CART','POLY','SHET','STIK','THRE','FOAM','SEET','LABL','PAPR','HANG','ACCS') or (head_code in('TAGS','PINS') and trim(fab_desc) like 'HK%'))";
        List<Map<String, Object>> li = template.queryForList(sql);
        if (!li.isEmpty()) {
            for (Map row : li) {
                if (row.get("HEAD_CODE").equals("THRE")) {
                    js.put("colourenableflag", "true");
                } else {
                    js.put("colour", 28);
                    js.put("colourenableflag", "false");
                    js.put("sizeenableflag", "true");
                }
            }
        }
        else
        {
             js.put("incorrectflag", "true");
              js.put("incorrectflagmsg", "Item code is Incorrect");
        }
        return js;

    }
     public List getColourBom4() {
        String sql = "SELECT * FROM COLOUR WHERE FLAG IS NULL order by colour_code";
        List li = template.queryForList(sql);
        String a ="hello";
   String b = new String("hello");
   if(a.equals(b))
   {
       System.out.println("equal");
   }
   else
   {
       System.out.println("not equal====");
   }
        return li;
    }
}
