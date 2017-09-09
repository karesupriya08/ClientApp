/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.eclipsesource.json.Json;
import com.rmx.clientapp.Model.Invoice;
import com.rmx.clientapp.Model.Order;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.json.simple.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;

public class InvoiceDao {

    JdbcTemplate template;
    String sql = null;
    String msg = null;
    int cnt = 0;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public JSONObject checkSerial(int serial, String seas_code) {
        String msg = null;
        JSONObject js = new JSONObject();
        sql = "select count(*) from ship" + seas_code + " where serial = '" + serial + "' ";
        //  System.out.println("sql==========" + sql);

        int r = template.queryForObject(sql, Integer.class);
        // System.out.println("res========" + r);
        if (r == 0) {
            msg = "No such Serial Found";
            cnt = 1;
        } else {
            cnt = 0;
            sql = "select colour.colour_code,colour.colour_desc from ship" + seas_code + " , colour where serial = '" + serial + "'and colour.colour_code=shipping.ship" + seas_code + ".COLOUR and cancel is null ";
            List colorlist = template.queryForList(sql);
            //   System.out.println("colorlist=============" + colorlist);
            Set hs = new HashSet();
            hs.addAll(colorlist);
            //   System.out.println("hs=======" + hs);
            js.put("colorlist", hs);
        }
        js.put("cnt", cnt);
        return js;
    }

    public JSONObject getShipNo(int serial, String seas_code, int colour) {
        JSONObject js = new JSONObject();
        sql = "select ship_no from ship" + seas_code + "  where serial = '" + serial + "'and colour='" + colour + "' and cancel is null ";
        List shiplist = template.queryForList(sql);
        // System.out.println("shiplist========" + shiplist);
        js.put("shiplist", shiplist);
        return js;
    }

    public JSONObject checkShipStatus(int serial, String seas_code, int colour, int ship_no) {
        String msg = null;
        sql = "select cancel,ship_raise,buyer_code,style_no,order_qty from ship" + seas_code + "  where ship_no='" + ship_no + "' and serial = '" + serial + "' and colour='" + colour + "' and cancel is null ";
        return template.queryForObject(sql, new RowMapper<JSONObject>() {
            public JSONObject mapRow(ResultSet rs, int row) throws SQLException {
                System.out.println("sql===" + sql);
                JSONObject js = new JSONObject();
                String msg = null;
                String flag = null;
                String cancel;
                String ship_raise;
                System.out.println("cancel=====" + rs.getString("cancel"));

                System.out.println("ship_raise=====" + rs.getString(2));
                cancel = rs.getString("cancel");
                ship_raise = rs.getString("ship_raise");
                System.out.println("ship_raise=====" + ship_raise);
                if (rs.getString("cancel") == null) {
                    cancel = "";
                    System.out.println("cancel=======" + cancel);
                }
                if (rs.getString("ship_raise") == null) {
                    ship_raise = "";
                    System.out.println("ship_raise=======" + ship_raise);
                }

                if ((cancel.equals("C"))) {
                    msg = "Ship No. Is Already Cancel";
                    flag = "C";
                    js.put("flag", flag);
                    js.put("msg", msg);
                } else if ((ship_raise.equals("Y"))) {
                    msg = "Shipping Invoice Raised You Can Not Cancel This Invoice Number.";
                    flag = "Y";
                    js.put("flag", flag);
                    js.put("msg", msg);
                } else {
                    System.out.println("in else=========");
                    js.put("buyer_code", rs.getString("buyer_code"));
                    js.put("style_no", rs.getString("style_no"));
                    js.put("order_qty", rs.getInt("order_qty"));
                }

                return js;
            }
        });

    }

    public JSONObject cancelInvoice(final Invoice invoice) {
        System.out.println("In cancel invoice====");

        sql = "select * from seasyr where season=" + invoice.getSeason() + "";
        return template.query(sql, new ResultSetExtractor<JSONObject>() {

            public JSONObject extractData(ResultSet rs) throws SQLException,
                    DataAccessException {
                JSONObject js = new JSONObject();
                String sql1 = null;
                String msg = null;
                String sql = null;
                while (rs.next()) {
                    sql1 = "select count(*) from shipping.invoic" + rs.getString(2) + rs.getString(3) + " where cl_ship ='" + invoice.getShip_no() + "' and SEASON ='" + invoice.getSeason() + "' and cancel is null";
                    int cnt = template.queryForObject(sql1, Integer.class);
                    System.out.println("cnt=========" + cnt);
                    System.out.println("searson end year==========" + rs.getString(2) + rs.getString(3));
                    if (cnt > 0) {
                        msg = "Invoice Already Raised By Shipping Can Not Cancel. Firstly Shipping Invoice Has To Be Cancelled ";
                        js.put("msg", msg);
                        break;
                    } else {
                        System.out.println("in else");
                        sql = "update SHIPPING.SHIP" + invoice.getSeason() + " set cancel='C' Where serial='" + invoice.getSerial() + "' and colour= '" + invoice.getColour() + "' and ship_no='" + invoice.getShip_no() + "'";
                        int i = template.update(sql);
                        System.out.println("update res=========" + i);
                        msg = "Invoice has been cancelled";
                        js.put("msg", msg);
                    }
                }
                return js;
            }

        });
    }

    public JSONObject getStyleNo(String seas_code) {
        JSONObject js = new JSONObject();
        try {
            String sql = "select distinct(style_no) from size" + seas_code + " where cancel is null and style_no is not null";
            List style_no = template.queryForList(sql);
            js.put("style_no", style_no);
        } catch (Exception e) {
            js.put("msg", "No Style_no found...");
            js.put("flag", "false");
        }

        return js;
    }

    public JSONObject getBuyerCode(String seas_code, String style_no) {
        JSONObject js = new JSONObject();

        try {
            String sql = "select distinct buyer_code from order" + seas_code + " where style_no ='" + style_no + "' and cancel is null";
            List buyer_code = template.queryForList(sql);
            js.put("buyer_code", buyer_code);
        } catch (Exception e) {
            js.put("msg", "No BuyerCode found...");
            js.put("flag", "false");
        }

        return js;
    }

    public JSONObject getOrderdata(String seas_code, String buyer_code, String style_no) {
        JSONObject js = new JSONObject();
        String sql = null, sqlship = null;
        float NETREQ = 0;
        int raised = 0, bal = 0, ordqty;
        ArrayList al = new ArrayList();
        if (buyer_code.equals("MACL")) {
            js.put("head", "Order + 5%");
        } else {
            js.put("head", "Order + 10%");
        }
        sql = "select nvl(price,0) price,serial,colour,sum(order_qty) order_qty from order" + seas_code + " where style_no ='" + style_no + "' and cancel is null and buyer_code='" + buyer_code + "' group by serial,colour, price order by price";
        List<Map<String, Object>> lidata = template.queryForList(sql);
        // System.out.println("lidata------------------" + lidata);
        for (Map row : lidata) {
            JSONObject shipdata = new JSONObject();
            ordqty = Integer.parseInt(row.get("order_qty").toString());
            if (buyer_code.equals("MACL")) {
                NETREQ = (float) (ordqty + (ordqty * 0.05));
            } else {
                NETREQ = (float) (ordqty + (ordqty * 0.1));
            }
            shipdata.put("serial", row.get("serial"));
            shipdata.put("colour", row.get("colour"));
            shipdata.put("order_qty", row.get("order_qty"));
            shipdata.put("order_per", NETREQ);
            shipdata.put("price", row.get("price"));
            sqlship = "SELECT sum(ORDER_QTY) order_qty FROM SHIP" + seas_code + " WHERE SERIAL = '" + row.get("serial") + "' AND COLOUR ='" + row.get("colour") + "' AND CANCEL IS NULL";
            //  System.out.println("sql------------------" + sqlship);

            try {
                int ordraised = template.queryForObject(sqlship, Integer.class);
                // System.out.println("shiprec1---------------" + ordraised);
                raised = ordraised;
            } catch (Exception e) {
                raised = 0;
            }
            shipdata.put("raised", raised);
            bal = ordqty - raised;
            if (bal < 0) {
                bal = 0;
            }
            al.add(shipdata);
        }
        js.put("shipdata", al);
        /*List<Map<String, Object>> first = new ArrayList();
         for (int row = lidata.size() - 1; row >= 0; row--) {
         System.out.println("lidata---------------" + lidata.get(row));
         first.add(lidata.get(row));
        
         }
         int colour = 0, serial = 0;
         String Alraised = "";
         for (Map row : first) {
         colour = Integer.parseInt(row.get("COLOUR").toString());
         serial = Integer.parseInt(row.get("SERIAL").toString());
         }
         try {
         String sqlal = "SELECT sum(ORDER_QTY) order_qty FROM shipping.SHIP" + seas_code + " WHERE SERIAL = '" + serial + "' AND COLOUR = '" + colour + "' AND CANCEL IS NULL ";
         System.out.println("sql--------------" + sqlal);
         Integer order_qty = template.queryForObject(sqlal, Integer.class);
         System.out.println("raised--------------------" + order_qty);
         Alraised = order_qty.toString();
         } catch (Exception e) {
         Alraised = "";
         }
        
         String sqldisp = "select NVL(CURRENCY,' ') CURRENCY,nvl(b_style,' ') b_style,nvl(fab_con,' ') fab_con,nvl(fab_con2,' ') fab_con2,nvl(fab_con,' ') fab_con,nvl(quota_seg,' ') quota_seg,COMP_CODE,price,BUYER_CODE,ORDER_NO,ORDER_DATE,O.b_style,O.COLOUR,O.gar_desc,O.order_qty,O.wov_hos,O.price,O.quota_cat,O.serial,c.colour_desc,nvl(o.article_no,' ') article_no,nvl(dept,' ') dept,nvl(supplier,' ') supplier from order" + seas_code + " o, colour c where  cancel is null AND o.STYLE_NO = '" + style_no + "' and buyer_code='" + buyer_code + "' and serial='" + serial + "' and o.colour=c.colour_code AND O.COLOUR= '" + colour + "'";
         System.out.println("sql--------------" + sqldisp);
         List<Map<String, Object>> lidisp = template.queryForList(sqldisp);
         System.out.println("list----------------------" + lidisp);
         JSONObject disp = new JSONObject();
         SimpleDateFormat dt1 = new SimpleDateFormat("dd/MM/yyyy");
         for (Map row : lidisp) {
         disp.put("b_style", row.get("b_style"));
         disp.put("buyer_code", row.get("buyer_code"));
         disp.put("style_no", row.get("style_no"));
         disp.put("serial", row.get("serial"));
         disp.put("gar_desc", row.get("gar_desc"));
        
         disp.put("wov_hos", row.get("wov_hos"));
         disp.put("order_qty", row.get("order_qty"));
         disp.put("main_fab", row.get("main_fab"));
        
         disp.put("b_style", row.get("b_style"));
         disp.put("quota_seg", row.get("quota_seg"));
         disp.put("price", row.get("price"));
         disp.put("currency", row.get("currency"));
         disp.put("quota_cat", row.get("quota_cat"));
         disp.put("gar_desc", row.get("gar_desc"));
        
         String order_date = dt1.format(row.get("order_date"));
         disp.put("order_date", order_date);
         disp.put("order_no", row.get("order_no"));
         disp.put("fab_con", row.get("fab_con"));
         disp.put("fab_con2", row.get("fab_con2"));
         disp.put("comp_code", row.get("comp_code"));
        
         System.out.println("disp-----------------------------" + disp);
         //  js.put("order_no", row.get("order_no"));
         }
         disp.put("alraised", Alraised);
         js.put("disp", disp);*/
        //System.out.println("disp json-------------------" + disp.toJSONString());
        return js;
    }

    public JSONObject getOrderdataforInvoiceEntryClick(String seas_code, String buyer_code, String style_no, int serial, int colour) {
        JSONObject js = new JSONObject();
        String Alraised = "";

        try {
            String sqlal = "SELECT sum(ORDER_QTY) order_qty FROM SHIP" + seas_code + " WHERE SERIAL = '" + serial + "' AND COLOUR = '" + colour + "' AND CANCEL IS NULL ";
            //  System.out.println("sql--------------" + sqlal);
            Integer order_qty = template.queryForObject(sqlal, Integer.class);
            //   System.out.println("raised--------------------" + order_qty);
            Alraised = order_qty.toString();
        } catch (Exception e) {
            Alraised = "";
        }
        String sqldisp = "select NVL(CURRENCY,' ') CURRENCY,nvl(b_style,' ') b_style,nvl(fab_con,' ') fab_con,nvl(fab_con2,' ') fab_con2,nvl(fab_con,' ') fab_con,nvl(quota_seg,' ') quota_seg,COMP_CODE,price,BUYER_CODE,ORDER_NO,ORDER_DATE,O.b_style,O.COLOUR,O.gar_desc,O.order_qty,O.wov_hos,O.price,O.quota_cat,O.serial,c.colour_desc,nvl(o.article_no,' ') article_no,nvl(dept,' ') dept,nvl(supplier,' ') supplier from order" + seas_code + " o, colour c where  cancel is null AND o.STYLE_NO = '" + style_no + "' and buyer_code='" + buyer_code + "' and serial='" + serial + "' and o.colour=c.colour_code AND O.COLOUR= '" + colour + "'";
        //  System.out.println("sql--------------" + sqldisp);
        List<Map<String, Object>> lidisp = template.queryForList(sqldisp);
        System.out.println("list----------------------" + lidisp);
        JSONObject disp = new JSONObject();
        SimpleDateFormat dt1 = new SimpleDateFormat("dd/MM/yyyy");
        int qty = 0;
        for (Map row : lidisp) {
            disp.put("b_style", row.get("b_style"));
            disp.put("buyer_code", row.get("buyer_code"));
            disp.put("style_no", row.get("style_no"));
            disp.put("serial", row.get("serial"));
            disp.put("gar_desc", row.get("gar_desc"));

            disp.put("wov_hos", row.get("wov_hos"));
            qty = Integer.parseInt(row.get("order_qty").toString());
            disp.put("order_qty", row.get("order_qty"));
            disp.put("main_fab", row.get("main_fab"));

            disp.put("b_style", row.get("b_style"));
            disp.put("quota_seg", row.get("quota_seg"));
            disp.put("price", row.get("price"));
            disp.put("currency", row.get("currency"));
            disp.put("quota_cat", row.get("quota_cat"));
            disp.put("gar_desc", row.get("gar_desc"));

            String order_date = dt1.format(row.get("order_date"));
            disp.put("order_date", order_date);
            disp.put("order_no", row.get("order_no"));
            disp.put("fab_con", row.get("fab_con"));
            disp.put("fab_con2", row.get("fab_con2"));
            disp.put("comp_code", row.get("comp_code"));
            if(buyer_code.equals("OTAM") || buyer_code.equals("OTAP") || buyer_code.equals("OTHN"))
            {
                if(row.get("article_no").toString().length()==0 || row.get("dept").toString().length()==0  || row.get("supplier").toString().length()==0)
                {
                    js.put("msg", "Article No./Dept./Supplier Entry Missing ");
                    break;
                }
                disp.put("article_no", row.get("article_no"));
                 disp.put("dept", row.get("dept"));
                  disp.put("supplier", row.get("supplier"));
                  disp.put("articleflag", "true");
            }
            int comp_code = Integer.parseInt(row.get("comp_code").toString());
            if (comp_code == 1) {
                disp.put("comp_name", "R.M.X JOSS");
            }
            if (comp_code == 2) {
                disp.put("comp_name", "R.M.X JOSS MERCHANTS");
            }
            if (comp_code == 3) {
                disp.put("comp_name", "CATCH TRADING COMPANY");
            }
            if (comp_code == 6) {
                //  System.out.println("6");
                disp.put("comp_name", "R.M.X JOSS FASHIONS");
            }

            // System.out.println("disp-----------------------------" + disp);
            //  js.put("order_no", row.get("order_no"));
        }
        disp.put("alraised", Alraised);
        js.put("disp", disp);
        String sq = "select a.serial,a.colour,a.size_type,a.size_qty,b.price from size" + seas_code + " a,sizeprice" + seas_code + " b Where A.serial = b.serial And A.COLOUR = b.COLOUR and a.size_type=b.size_type and a.serial='" + serial + "' and a.colour='" + colour + "' ORDER BY B.PRICE";
        //   System.out.println("sq--------------" + sq);

        if (buyer_code.equals("NEXT") || buyer_code.equals("NEXB") || buyer_code.equals("NXT1") || buyer_code.equals("NXT2") || buyer_code.equals("NXT3") || buyer_code.equals("CHDS") || buyer_code.equals("BUGT") || buyer_code.equals("BRUM") || buyer_code.equals("MNTC") || buyer_code.equals("OTWW")) {
            js.put("sizewiseqtyflag", "true");
            js.put("sizewiseqty", sizebreakup("N", "Y", buyer_code, sq, qty));
        }

        return js;
    }

    public List sizebreakup(String FLG, String FLG1, String buyer_code, String sq, int qty) {

        String pp = "", ts = "";
        Integer tt = 0;
        ArrayList al = new ArrayList();
        int RR = 1;
        int tt1 = 0;
        if (FLG1.equals("Y")) {
            List<Map<String, Object>> li = template.queryForList(sq);
            //System.out.println("li---size-------------------------" + li);

            for (Map row : li) {
                JSONObject js = new JSONObject();
                pp = row.get("price").toString();
                //   System.out.println("pp-----------" + pp);
                for (Map commrow : li) {
                    if (pp.equals(commrow.get("price").toString())) {
                        // System.out.println("in if=--------------");
                        tt = tt + Integer.parseInt(commrow.get("size_qty").toString());
                        ts = ts + commrow.get("size_type").toString() + ",";
                        // System.out.println("price-----------"+commrow.get("price"));
                    }
                }
                // System.out.println("tt---------------------" + tt);
                // System.out.println("ts-------------------" + ts);
                js.put("serial", row.get("serial"));
                js.put("colour", row.get("colour"));
                js.put("Sizes", ts);
                js.put("order_qty", tt);
                js.put("prices", pp);
                al.add(js);
                tt = 0;
                ts = "";
                RR = RR + 1;
                tt1 = tt1 + tt;
                // System.out.println("json-----------------"+js);
            }

            Set hs = new HashSet();
            hs.addAll(al);
            al.clear();
            al.addAll(hs);
            // System.out.println("al----------------------" + al);
        }
        return al;
    }

    public List getShippingUnit(String buyer_code, int comp_code) {
        String sql = null;
        List shipunit;
        if (buyer_code.equals("MARC")) {
            sql = "SELECT DISTINCT UNIT UNIT,NVL(NUNIT_NAME,'') NUNIT_NAME FROM SHIPPING.UNIT where dis_flag='Y'";
        } else {
            sql = "SELECT DISTINCT UNIT UNIT,NVL(NUNIT_NAME,'') NUNIT_NAME FROM SHIPPING.UNIT WHERE COMP_CODE='" + comp_code + "' and  dis_flag='Y'";
        }
        //  System.out.println("sql=================="+sql);
        shipunit = template.queryForList(sql);
        //  System.out.println("li---------------"+shipunit);

        return shipunit;
    }

    public List getWorkUnit() {
        String sql = null;
        List workunit;
        sql = "SELECT DISTINCT UNIT UNIT1,NVL(NUNIT_NAME,'') NUNIT_NAME1 FROM SHIPPING.UNIT where dis_flag='Y' ";
        workunit = template.queryForList(sql);
        // System.out.println("workunit--------------------"+workunit);
        return workunit;
    }

    public int InsertIntotempInvoice(JSONObject tempinvoice) {
        String sql = "select sys_context('userenv','ip_address') ip from dual";
        String ipaddress = template.queryForObject(sql, String.class);
        String json = tempinvoice.toString();
        String insq = null;
        int colour = 0;
        int serial = 0;
        int inres = 0;
        int col;//= Json.parse(json).asObject().getInt("colour", 0);
        int ser;// = Json.parse(json).asObject().getInt("serial", 0);
        //System.out.println("col +ser========="+col+"    "+ser);
        com.eclipsesource.json.JsonArray items = Json.parse(json).asObject().get("size").asArray();
        for (com.eclipsesource.json.JsonValue item : items) {
            col = item.asObject().getInt("colour", 0);
            ser = item.asObject().getInt("serial", 0);
            String sqdel = "delete from tempinvoiceraise where serial='" + ser + "' and colour='" + col + "' and ipaddress='" + ipaddress + "'";
            System.out.println("sqdel resuly temp invoice--------" + sqdel);
            int res = template.update(sqdel);
            System.out.println("delete result=============" + res);
        }
        for (com.eclipsesource.json.JsonValue item : items) {
            String sizes = item.asObject().getString("Sizes", "");
            colour = item.asObject().getInt("colour", 0);
            serial = item.asObject().getInt("serial", 0);
            String price = item.asObject().getString("prices", "");
            int order_qty = item.asObject().getInt("order_qty", 0);
            int ship_qty = item.asObject().getInt("toraise", 0);
            if (ship_qty > 0) {
                // System.out.println("sizes-------" + sizes);
                // System.out.println("colour-------" + colour);
                insq = "insert into tempinvoiceraise(serial,colour,sizes,price,ship_qty,order_qty,ipaddress) values('" + serial + "','" + colour + "','" + sizes + "','" + price + "','" + ship_qty + "','" + order_qty + "','" + ipaddress + "')";
                System.out.println("insq------------" + insq);
                inres = template.update(insq);
                System.out.println("inres=-----------" + inres);
            }
        }
        return inres;
    }

    public JSONObject saveInvoiceenrty(JSONObject jsonObj) {
        JSONObject js = new JSONObject();
        String buyer_code = null;
        String seas_code = null;
        String style_no = null;
        String port = null;
        String b_style = null;
        String netstyleradio = null;
        String shipmentradio = null;
        String setradio = null;
        String modeship = null;
        String shipunit = null;
        String workuint = null;
        String aa = jsonObj.toString();
        System.out.println("aa----" + aa);
        String price_flag = "Y";
        String shiprec = null, TMPREC = null;
        String sqmrec1 = null, sqmrec = null;
        List<Map<String, Object>> mrec1;
        List<Map<String, Object>> mrec;
        int res = 0;
        int SHIPNO = 0;
        buyer_code = Json.parse(aa).asObject().get("buyer_code").asString();
        seas_code = Json.parse(aa).asObject().get("seas_code").asString();
        style_no = Json.parse(aa).asObject().get("style_no").asString();
        port = Json.parse(aa).asObject().get("port").asString();
        b_style = Json.parse(aa).asObject().get("b_style").asString();
        netstyleradio = Json.parse(aa).asObject().get("netstyleradio").asString();
        shipmentradio = Json.parse(aa).asObject().get("shipmentradio").asString();
        setradio = Json.parse(aa).asObject().get("setradio").asString();
        modeship = Json.parse(aa).asObject().get("modeship").asString();
        shipunit = Json.parse(aa).asObject().get("shipunit").asString();
        workuint = Json.parse(aa).asObject().get("workuint").asString();
        // System.out.println("buyer_code------------"+buyer_code+seas_code+style_no);
        if (shipunit.equals("B-37B")) {
            shipunit = "B-37";
        }
        if (workuint.equals("B-37B")) {
            workuint = "B-37";
        }

        int RLINK = 0;
        String SET_MARK = null;
        String EXTRA = "";
        String sql = "select sys_context('userenv','ip_address') ip from dual";
        String ipaddress = template.queryForObject(sql, String.class);
        System.out.println("ipaddres--------" + ipaddress);

        SimpleDateFormat dt = new SimpleDateFormat("dd-MMM-yy");
        Date curr_date = new Date();
        String todays_date = dt.format(curr_date);
        if (buyer_code.equals("OTCF") || buyer_code.equals("OTPS")) {
            buyer_code = "OTTO";
        } else if (buyer_code.equals("TVWA") || buyer_code.equals("TVAN") || buyer_code.equals("TVBF")) {
            buyer_code = "TVFR";
        }
        if (buyer_code.equals("NEXT") || buyer_code.equals("NEXB") || buyer_code.equals("NXT1") || buyer_code.equals("NXT2") || buyer_code.equals("NXT3") || buyer_code.equals("CHDS") || buyer_code.equals("BUGT") || buyer_code.equals("BRUM") || buyer_code.equals("MNTC") || buyer_code.equals("OTWW")) {
            sqmrec1 = "select serial,colour,ship_qty,price from tempinvoiceraise where ipaddress='" + ipaddress + "'";
            System.out.println("sqmrec1------------------" + sqmrec1);
            mrec1 = template.queryForList(sqmrec1);
            System.out.println("mrec1-----------" + mrec1);
            if (!mrec1.isEmpty()) {
                shiprec = "select link_no from SHIPPING.shipcont where season ='" + seas_code + "'";
                    SHIPNO = template.queryForObject(shiprec, Integer.class);
                    sql = "update SHIPPING.shipcont set link_no= '" + (SHIPNO + 1) + "' where season='" + seas_code + "'";
                    res = template.update(sql);
                for (Map rowmrec : mrec1) {
                    
                    //sqmrec="SELECT serial,colour,ship_qty,price FROM TEMPINVOICERAISE WHERE IPADDRESS='"+ipaddress+"' and price='"+row.get("PRICE")+"'";
                    // mrec=template.queryForList(sqmrec);
                    if (setradio.equals("Y")) {
                        String sq = "select * from shipping.ship" + seas_code + " where comb_link='" + SHIPNO + "' and cancel is null";
                        List li = template.queryForList(sq);
                        if (!li.isEmpty()) {
                            RLINK = SHIPNO - 1;
                        } else {
                            RLINK = SHIPNO + 1;
                        }
                        SET_MARK = "Y";
                    } else {
                        SET_MARK = "N";
                    }
                    TMPREC = "insert into SHIPPING.SHIP" + seas_code + "(serial,colour,buyer_code,season,order_qty,style_no,ship_no,cl_date,b_style,price,PORT_DISCH,NSTYLE,SET_MARK,comb_link,EXTRA,ship_mode,LC,unit,WORK_UNIT,price_flag) values('" + rowmrec.get("serial") + "','" + rowmrec.get("colour") + "','" + buyer_code + "','" + seas_code + "','" + rowmrec.get("ship_qty") + "','" + style_no + "','" + SHIPNO + "','" + todays_date + "','" + b_style + "','" + rowmrec.get("price") + "','" + port + "','" + netstyleradio + "','" + SET_MARK + "','" + RLINK + "','" + EXTRA + "','" + modeship + "','" + shipmentradio + "','" + shipunit + "','" + workuint + "','" + price_flag + "') ";
                    System.out.println("TMPREC------------" + TMPREC);
                    res = template.update(TMPREC);
                    System.out.println("Result of insert in shgipping ,ship----------" + res);
                    if (res > 0) {
                        js.put("msg", "Invoice has been raised...");
                        js.put("flag", "true");
                    } else {
                        js.put("msg", "Invoice has not been raised...");
                        js.put("flag", "false");
                    }
                }
            }

        } else {
            shiprec = "";
            int ship_qty = 0;
            int serial, colour, order_qty, toship;
            float price;
            System.out.println("in else of buyer");

            shiprec = "select link_no from SHIPPING.shipcont where season ='" + seas_code + "'";
            System.out.println("shiprec-----------" + shiprec);
            SHIPNO = template.queryForObject(shiprec, Integer.class);
            System.out.println("SHIPNO---------" + SHIPNO);
            sql = "update SHIPPING.shipcont set link_no= '" + (SHIPNO + 1) + "' where season='" + seas_code + "'";
            res = template.update(sql);
            com.eclipsesource.json.JsonArray items = Json.parse(aa).asObject().get("data").asArray();
            for (com.eclipsesource.json.JsonValue item : items) {
                ship_qty = item.asObject().getInt("toship", 0);
                System.out.println("ship qty=----------" + ship_qty);
                if (ship_qty > 0) {
                    serial = item.asObject().getInt("serial", 0);
                    colour = item.asObject().getInt("colour", 0);
                    price = item.asObject().getFloat("price", 0);
                    order_qty = item.asObject().getInt("toship", 0);
                    if (setradio.equals("Y")) {
                        String sq = "select * from shipping.ship" + seas_code + " where comb_link='" + SHIPNO + "' and cancel is null";
                        List li = template.queryForList(sq);
                        if (!li.isEmpty()) {
                            RLINK = SHIPNO - 1;
                        } else {
                            RLINK = SHIPNO + 1;
                        }
                        SET_MARK = "Y";
                    } else {
                        SET_MARK = "N";
                    }
                    TMPREC = "insert into SHIPPING.SHIP" + seas_code + "(serial,colour,buyer_code,season,order_qty,style_no,ship_no,cl_date,b_style,price,PORT_DISCH,NSTYLE,SET_MARK,comb_link,EXTRA,ship_mode,LC,unit,WORK_UNIT,price_flag) values('" + serial + "','" + colour + "','" + buyer_code + "','" + seas_code + "','" + order_qty + "','" + style_no + "','" + SHIPNO + "','" + todays_date + "','" + b_style + "','" + price + "','" + port + "','" + netstyleradio + "','" + SET_MARK + "','" + RLINK + "','" + EXTRA + "','" + modeship + "','" + shipmentradio + "','" + shipunit + "','" + workuint + "','" + price_flag + "') ";
                    System.out.println("TMPREC------------" + TMPREC);
                    res = template.update(TMPREC);
                    System.out.println("Result of insert in shgipping ,ship----------" + res);
                    if (res > 0) {
                        js.put("msg", "Invoice has been raised...");
                        js.put("flag", "true");
                    } else {
                        js.put("msg", "Invoice has not been raised...");
                        js.put("flag", "false");
                    }
                }
            }
        }

        return js;
    }

    public void Inserttempship(int serial, int colour, float price) {
        String sql = null;
        sql = "insert into tempship (serial,colour,price) values('" + serial + "','" + colour + "','" + price + "')";
        int res = template.update(sql);
        System.out.println("insert temp ship res========" + res);
    }

    public void Trunctempship() {
        String sql = null;
        sql = "TRUNCATE TABLE TEMPSHIP";
        int res = template.update(sql);
        System.out.println("trunc tableres---------" + res);
    }
}
