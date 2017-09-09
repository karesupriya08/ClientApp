/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.rmx.clientapp.Model.Order;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 *
 * @author Sanjay geda
 */
public class FabDao {

    JdbcTemplate template;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public List getSerial(String seas_code, String buyer_code, String style_no) {
        String sql = "select distinct serial from order" + seas_code + " where cancel is null and buyer_code ='" + buyer_code + "' and style_no='" + style_no + "' ";
        List serial = template.queryForList(sql);
        return serial;

    }

    public List getColour(String seas_code, String buyer_code, String style_no, int serial) {
        String sql = "select distinct colour from order" + seas_code + " where cancel is null and buyer_code ='" + buyer_code + "' and style_no='" + style_no + "' and serial='" + serial + "'";
        List colourList = template.queryForList(sql);
        return colourList;

    }

    public JSONObject getdata(String seas_code, int serial, int colour) {
        String msg = "", strFAB_RATE = "";
        JSONObject js = new JSONObject();
        Integer FAB_RATE = 0;
        Integer INTFAB_RATE = 0;
        String fab, fabin = "";
        String strnull = null;
        String sql = "select style_no,b_style,order_qty,FAB_RATE,INTFAB_RATE from order" + seas_code + " where cancel is null and colour ='" + colour + "'  and serial='" + serial + "'";
        List<Map<String, Object>> dataList = template.queryForList(sql);
        if (!dataList.isEmpty()) {
            for (Map row : dataList) {
                js.put("STYLE_NO", row.get("style_no"));
                js.put("B_STYLE", row.get("b_style"));
                js.put("ORDER_QTY", row.get("order_qty"));
                try {
                    FAB_RATE = Integer.parseInt(row.get("FAB_RATE").toString());
                } catch (Exception e) {
                    FAB_RATE = 0;
                }
                try {
                    INTFAB_RATE = Integer.parseInt(row.get("INTFAB_RATE").toString());
                } catch (Exception e) {
                    INTFAB_RATE = 0;
                }
                if (FAB_RATE <= 1) {
                    if (FAB_RATE == 0) {
                        fab = "";
                    } else {
                        fab = FAB_RATE.toString();
                    }
                    if (INTFAB_RATE == 0) {
                        fabin = "";
                    } else {
                        fabin = INTFAB_RATE.toString();
                    }
                } else {
                    fab = FAB_RATE.toString();
                    js.put("embflag", "true");
                    js.put("fabdis", "true");
                }
                js.put("fab", fab);
                js.put("fabin", fabin);

            }
        } else {
            msg = "No such combination found...........";
            js.put("msg", msg);
            js.put("flag", "false");
        }

        return js;

    }

    public JSONObject getOtherDetails(String seas_code, String style_no, int serial, String allcontrol, int colour) {
        String sql = "";
        JSONObject js = new JSONObject();
        List<Map<String, Object>> details;
        if (allcontrol.equals("true")) {
            sql = "select NVL(HD_RATE,0) HD_RATE,NVL(MC_RATE,0) MC_RATE,NVL(AR_RATE,0) AR_RATE,NVL(OTHERS,0) OTHERS,NVL(OTH1,0) OTH1,NVL(OTH2,0) OTH2,NVL(OTH3,0) OTH3 ,NVL(OTH4,0) OTH4, NVL(OTH5,0) OTH5,NVL(OTH6,0) OTH6,NVL(OTH7,0) OTH7,NVL(OTH8,0) OTH8,NVL(OTH9,0) OTH9, oth_desc othdesc,oth1_desc oth1desc ,oth2_desc oth2desc,oth3_desc oth3desc,oth4_desc oth4desc,oth5_desc oth5desc,oth6_desc oth6desc,oth7_desc oth7desc,oth8_desc oth8desc,oth9_desc oth9desc,OTH1_SEQ,OTH2_SEQ,OTH3_SEQ,OTH4_SEQ,OTH5_SEQ,OTH6_SEQ,OTH7_SEQ,OTH8_SEQ,OTH9_SEQ,OTH10_SEQ from order" + seas_code + " where style_no='" + style_no + "' AND cancel is null ORDER BY SERIAL ";
            System.out.println("sql-----------------" + sql);
            details = template.queryForList(sql);
            System.out.println("list-----------------" + details);

            for (Map row : details) {
                js.put("HD_RATE", row.get("HD_RATE"));
                js.put("MC_RATE", row.get("MC_RATE"));
                js.put("AR_RATE", row.get("AR_RATE"));
                js.put("OTHERS", row.get("OTHERS"));
                js.put("OTH1", row.get("OTH1"));
                js.put("OTH2", row.get("OTH2"));
                js.put("OTH3", row.get("OTH3"));
                js.put("OTH4", row.get("OTH4"));
                js.put("OTH5", row.get("OTH5"));
                js.put("OTH6", row.get("OTH6"));
                js.put("OTH7", row.get("OTH7"));
                js.put("OTH8", row.get("OTH8"));
                js.put("OTH9", row.get("OTH9"));
                js.put("OTHDESC", row.get("OTHDESC"));
                js.put("OTH1DESC", row.get("OTH1DESC"));
                js.put("OTH2DESC", row.get("OTH2DESC"));
                js.put("OTH3DESC", row.get("OTH3DESC"));
                js.put("OTH4DESC", row.get("OTH4DESC"));
                js.put("OTH5DESC", row.get("OTH5DESC"));
                js.put("OTH6DESC", row.get("OTH6DESC"));
                js.put("OTH7DESC", row.get("OTH7DESC"));
                js.put("OTH8DESC", row.get("OTH8DESC"));
                js.put("OTH9DESC", row.get("OTH9DESC"));

            }
        } else {
            sql = "select NVL(HD_RATE,0) HD_RATE,NVL(MC_RATE,0) MC_RATE,NVL(AR_RATE,0) AR_RATE,NVL(OTHERS,0) OTHERS,NVL(OTH1,0) OTH1,NVL(OTH2,0) OTH2,NVL(OTH3,0) OTH3 ,NVL(OTH4,0) OTH4 ,NVL(OTH5,0) OTH5 ,NVL(OTH6,0) OTH6,NVL(OTH7,0) OTH7,NVL(OTH8,0) OTH8,NVL(OTH9,0) OTH9,oth_desc othdesc,oth1_desc oth1desc ,oth2_desc oth2desc,oth3_desc oth3desc,oth4_desc oth4desc, oth5_desc oth5desc,oth6_desc oth6desc,oth7_desc oth7desc,oth8_desc oth8desc,oth9_desc oth9desc,OTH1_SEQ,OTH2_SEQ,OTH3_SEQ,OTH4_SEQ,OTH5_SEQ,OTH6_SEQ,OTH7_SEQ,OTH8_SEQ,OTH9_SEQ,OTH10_SEQ from order" + seas_code + " where style_no='" + style_no + "' AND cancel is null and serial='" + serial + "' and colour='" + colour + "' ORDER BY SERIAL";
            details = template.queryForList(sql);
            System.out.println("list-----------------" + details);
            for (Map row : details) {
                js.put("HD_RATE", row.get("HD_RATE"));
                js.put("MC_RATE", row.get("MC_RATE"));
                js.put("AR_RATE", row.get("AR_RATE"));
                js.put("OTHERS", row.get("OTHERS"));
                js.put("OTH1", row.get("OTH1"));
                js.put("OTH2", row.get("OTH2"));
                js.put("OTH3", row.get("OTH3"));
                js.put("OTH4", row.get("OTH4"));
                js.put("OTH5", row.get("OTH5"));
                js.put("OTH6", row.get("OTH6"));
                js.put("OTH7", row.get("OTH7"));
                js.put("OTH8", row.get("OTH8"));
                js.put("OTH9", row.get("OTH9"));
                js.put("OTHDESC", row.get("OTHDESC"));
                js.put("OTH1DESC", row.get("OTH1DESC"));
                js.put("OTH2DESC", row.get("OTH2DESC"));
                js.put("OTH3DESC", row.get("OTH3DESC"));
                js.put("OTH4DESC", row.get("OTH4DESC"));
                js.put("OTH5DESC", row.get("OTH5DESC"));
                js.put("OTH6DESC", row.get("OTH6DESC"));
                js.put("OTH7DESC", row.get("OTH7DESC"));
                js.put("OTH8DESC", row.get("OTH8DESC"));
                js.put("OTH9DESC", row.get("OTH9DESC"));
            }
        }
        return js;
    }

    public JSONObject getallcontrol(String seas_code, String buyer_code, String style_no) {
        String msg = "";
        JSONObject js = new JSONObject();
        int ZZRATE = 0, INTRATE = 0, tt = 0;
        Integer FAB_RATE = 0;
        Integer INTFAB_RATE = 0;
        Integer FAB_RATERS1 = 0;
        Integer INTFAB_RATERS1 = 0, RATERS1 = 0;
        List<Map<String, Object>> rs1;
        String fab = "", fabin = "";
        String sql = "SELECT * FROM ORDER" + seas_code + " WHERE STYLE_NO='" + style_no + "' AND BUYER_CODE='" + buyer_code + "'  AND CANCEL IS NULL ORDER BY SERIAL";
        System.out.println("sql------------------" + sql);
        List<Map<String, Object>> rs = template.queryForList(sql);
        System.out.println("list--------------" + rs);

        if (rs.isEmpty()) {
            msg = "NO SUCH TRANSACTION FOUND FOR THIS STYLE/BUYER";
            js.put("msg", msg);
        } else {
            String sql1 = "SELECT NVL(MAX(FAB_RATE),0) RATE,NVL(MAX(INTFAB_RATE),0) INTFABRATE FROM ORDER" + seas_code + " WHERE STYLE_NO='" + style_no + "'  AND CANCEL IS NULL ";
            rs1 = template.queryForList(sql1);
            if (!rs1.isEmpty()) {
                for (Map row : rs1) {
                    ZZRATE = Integer.parseInt(row.get("RATE").toString());
                    INTRATE = Integer.parseInt(row.get("INTFABRATE").toString());
                }
            } else {
                ZZRATE = 0;
                INTRATE = 0;
            }
            for (Map row : rs) {
                System.out.println("qty=======================" + row.get("order_qty"));
                tt = tt + Integer.parseInt(row.get("order_qty").toString());
                js.put("STYLE_NO", row.get("style_no"));
                js.put("BUYER_CODE", row.get("buyer_code"));
                js.put("B_STYLE", row.get("b_style"));
                js.put("ORDER_QTY", tt);
                try {
                    FAB_RATE = Integer.parseInt(row.get("FAB_RATE").toString());
                } catch (Exception e) {
                    FAB_RATE = 0;
                }
                try {
                    INTFAB_RATE = Integer.parseInt(row.get("INTFAB_RATE").toString());
                } catch (Exception e) {
                    INTFAB_RATE = 0;
                }

                if (FAB_RATE <= 1 || row.get("FAB_RATE").equals("")) {
                    rs1.clear();
                    String sq = "SELECT NVL(MAX(FAB_RATE),0) RATE,NVL(MAX(INTFAB_RATE),0) INTFABRATE FROM ORDER" + seas_code + " WHERE STYLE_NO='" + style_no + "'  AND CANCEL IS NULL ";
                    rs1 = template.queryForList(sq);
                    if (!rs1.isEmpty()) {
                        for (Map row1 : rs1) {
                            try {
                                FAB_RATERS1 = Integer.parseInt(row1.get("FAB_RATE").toString());
                            } catch (Exception e) {
                                FAB_RATERS1 = 0;
                            }
                            try {
                                INTFAB_RATERS1 = Integer.parseInt(row1.get("INTFAB_RATE").toString());
                            } catch (Exception e) {
                                INTFAB_RATERS1 = 0;
                            }
                            try {
                                RATERS1 = Integer.parseInt(row1.get("Rate").toString());
                            } catch (Exception e) {
                                RATERS1 = 0;
                            }
                            if (RATERS1 <= 1) {
                                if (INTFAB_RATERS1 > 0) {
                                    fabin = INTFAB_RATERS1.toString();
                                    js.put("fabindis", "true");
                                }
                            } else {
                                fab = RATERS1.toString();
                                js.put("embflag", "true");
                                js.put("fabdis", "true");
                                if (INTFAB_RATERS1 > 0) {
                                    js.put("embflag", "true");
                                    js.put("fabindis", "true");
                                }
                            }
                        }
                    } else {
                        if (FAB_RATE == 0) {
                            if (INTFAB_RATE > 0) {
                                fabin = INTFAB_RATE.toString();
                                js.put("fabindis", "true");
                            }
                            fab = "";
                            js.put("fabdis", "false");
                        } else {
                            fab = FAB_RATE.toString();
                            js.put("fabdis", "true");
                        }
                    }
                } else {
                    if (ZZRATE > FAB_RATE) {
                        fab = new Integer(ZZRATE).toString();
                        if (INTFAB_RATERS1 > 0) {
                            js.put("embflag", "true");
                            js.put("fabindis", "true");

                        }
                    } else {
                        fab = FAB_RATE.toString();
                        js.put("fabdis", "true");
                        if (INTFAB_RATERS1 > 0) {
                            js.put("embflag", "true");
                            js.put("fabindis", "true");
                        } else {
                            js.put("fabindis", "false");
                        }
                    }
                }
                js.put("fab", fab);
                js.put("fabin", fabin);
            }
        }
        return js;

    }

    public List getWorkType() {
        String sql = null;
        sql = "select * from nature_wk where SEQ_NO<>11 order by work_seq";
        List li = template.queryForList(sql);
        return li;
    }

    public JSONObject updateFabRateEntry(Order o) {

        String sql = null;
        JSONObject js = new JSONObject();

        if (!o.getOth_desc().equals("")) {
            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOth1_seq(seq);
        }
        if (!o.getOth1_desc().equals("")) {

            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth1_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOth2_seq(seq);

        }
        if (!o.getOth2_desc().equals("")) {

            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth2_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOth3_seq(seq);

        }
        if (!o.getOth3_desc().equals("")) {
            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth3_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOth4_seq(seq);
        }
        if (!o.getOth4_desc().equals("")) {

            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth4_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOth5_seq(seq);
        }
        if (!o.getOth5_desc().equals("")) {
            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth5_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOth6_seq(seq);
        }
        if (!o.getOth6_desc().equals("")) {
            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth6_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOTH7_SEQ(seq);
        }
        if (!o.getOth7_desc().equals("")) {
            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth7_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOTH8_SEQ(seq);
        }
        if (!o.getOth8_desc().equals("")) {
            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth8_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOTH9_SEQ(seq);
        }
        if (!o.getOth9_desc().equals("")) {
            String a = "select work_seq from nature_wk where NATURE_DESC='" + o.getOth9_desc().trim() + "'";
            System.out.println("sql------------" + a);
            int seq = template.queryForObject(a, Integer.class);
            o.setOTH10_SEQ(seq);
        }
        if (o.getAllcontrol().equals("true")) {
            sql = "update order" + o.getSeas_code() + " set HD_RATE='" + o.getHd_rate() + "',MC_RATE ='" + o.getMc_rate() + "',AR_RATE='" + o.getAr_rate() + "',OTHERS='" + o.getOthers() + "',OTH1='" + o.getOth1() + "',OTH2='" + o.getOth2() + "',OTH3='" + o.getOth3() + "',OTH4='" + o.getOth4() + "',OTH5='" + o.getOth5() + "',OTH6='" + o.getOth6() + "',OTH7='" + o.getOth7() + "',OTH8='" + o.getOth8() + "',OTH9='" + o.getOth9() + "',oth_desc='" + o.getOth_desc() + "' ,oth1_desc='" + o.getOth1_desc() + "' ,oth2_desc='" + o.getOth2_desc() + "' ,oth3_desc='" + o.getOth3_desc() + "' ,oth4_desc='" + o.getOth4_desc() + "', oth5_desc='" + o.getOth5_desc() + "',OTH6_DESC='" + o.getOth6_desc() + "',OTH7_DESC='" + o.getOth7_desc() + "',OTH8_DESC='" + o.getOth8_desc() + "',OTH9_DESC='" + o.getOth9_desc() + "',FAB_RATE='" + o.getFab_rate() + "' ,INTFAB_RATE='" + o.getIntfab_rate() + "', oth1_seq='" + o.getOth1_seq() + "', oth2_seq='" + o.getOth2_seq() + "', oth3_seq='" + o.getOth3_seq() + "', oth4_seq='" + o.getOth4_seq() + "', oth5_seq='" + o.getOth5_seq() + "', oth6_seq='" + o.getOth6_seq() + "',OTH7_SEQ='" + o.getOTH7_SEQ() + "',OTH8_SEQ='" + o.getOTH8_SEQ() + "',OTH9_SEQ='" + o.getOTH9_SEQ() + "',OTH10_SEQ='" + o.getOTH10_SEQ() + "' WHERE Style_no='" + o.getStyle_no() + "' AND cancel is null";
            System.out.println("sql-------------" + sql);
            int resup = template.update(sql);
            if(resup>0)
            {
                js.put("msg","Fab rate Entry has been updated...");
            }
            else
            {
                 js.put("msg","Fab rate Entry has not been updated...");
            }
        } else {
            sql = "update order" + o.getSeas_code() + " set HD_RATE='" + o.getHd_rate() + "',MC_RATE ='" + o.getMc_rate() + "',AR_RATE='" + o.getAr_rate() + "',OTHERS='" + o.getOthers() + "',OTH1='" + o.getOth1() + "',OTH2='" + o.getOth2() + "',OTH3='" + o.getOth3() + "',OTH4='" + o.getOth4() + "',OTH5='" + o.getOth5() + "',OTH6='" + o.getOth6() + "',OTH7='" + o.getOth7() + "',OTH8='" + o.getOth8() + "',OTH9='" + o.getOth9() + "',oth_desc='" + o.getOth_desc() + "' ,oth1_desc='" + o.getOth1_desc() + "' ,oth2_desc='" + o.getOth2_desc() + "' ,oth3_desc='" + o.getOth3_desc() + "' ,oth4_desc='" + o.getOth4_desc() + "', oth5_desc='" + o.getOth5_desc() + "',OTH6_DESC='" + o.getOth6_desc() + "',OTH7_DESC='" + o.getOth7_desc() + "',OTH8_DESC='" + o.getOth8_desc() + "',OTH9_DESC='" + o.getOth9_desc() + "',FAB_RATE='" + o.getFab_rate() + "' ,INTFAB_RATE='" + o.getIntfab_rate() + "', oth1_seq='" + o.getOth1_seq() + "', oth2_seq='" + o.getOth2_seq() + "', oth3_seq='" + o.getOth3_seq() + "', oth4_seq='" + o.getOth4_seq() + "', oth5_seq='" + o.getOth5_seq() + "', oth6_seq='" + o.getOth6_seq() + "',OTH7_SEQ='" + o.getOTH7_SEQ() + "',OTH8_SEQ='" + o.getOTH8_SEQ() + "',OTH9_SEQ='" + o.getOTH9_SEQ() + "',OTH10_SEQ='" + o.getOTH10_SEQ() + "' where style_no='" + o.getStyle_no() + "' AND serial='" + o.getSerial() + "' and colour='" + o.getColour() + "'  and  cancel is null";
            System.out.println("sql-------------" + sql);
            int resup = template.update(sql);
             if(resup>0)
            {
                js.put("msg","Fab rate Entry has been updated...");
            }
            else
            {
                 js.put("msg","Fab rate Entry has not been updated...");
            }
        }
        return js;
    }
}
