/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Model;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import org.hibernate.validator.constraints.NotEmpty;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class Order {

    @NotEmpty(message = "Please enter your season.")
    private String seas_code;
    private String buyer_code;
    private int ord_stat;
    private String b_style;
    private List seasonList;
    private String quota_seg;
    private String quota_cat;
    private Date order_date;
    private String garment_desc;
    private String int_ord;
    private Season seasonbean;
    private int serial;
    private String style_no;
    private int order_qty;
    private Date delv_date;
    private float price;
    private String wov_hos;
    private String order_no;
    private String currency;
    private String emb_fl;
    private String main_fab;
    private String print;
    private String fab_con;
    private int comp_code;
    private String dyed;
    private int colour;
    private int colour_code;
    private JSONArray choices;
    private String p_type;
    private String colour_way;
    private String agent_comm;
    private String quota_grp;
    private String assort;
    private int comm_perc;
    private JSONObject data;
    private JSONArray sizeprice;
    private int fab_rate;
    private int intfab_rate;
    private int hd_rate;
    private int mc_rate;
    private int ar_rate;
    private int others;
    private int oth1;
    private int oth2;
    private int oth3, oth4, oth5, oth6, oth7, oth8, oth9;
    private String oth_desc, oth1_desc, oth2_desc, oth3_desc, oth4_desc, oth5_desc;
    private String oth6_desc, oth7_desc, oth8_desc, oth9_desc;
    private int oth1_seq, oth2_seq, oth3_seq, oth4_seq, oth5_seq, oth6_seq;
    private int OTH7_SEQ, OTH8_SEQ, OTH9_SEQ, OTH10_SEQ;
    private String allcontrol;

    public Order() {
    }

    public Order(String season, String buyer_code, int order_status, String b_style) {
        this.seas_code = season;
        this.buyer_code = buyer_code;
        this.ord_stat = order_status;
        this.b_style = b_style;
    }

    public String getSeas_code() {
        return seas_code;
    }

    public void setSeas_code(String seas_code) {
        this.seas_code = seas_code;
    }

    public String getBuyer_code() {
        return buyer_code;
    }

    public void setBuyer_code(String buyer_code) {
        this.buyer_code = buyer_code;
    }

    public int getOrd_stat() {
        return ord_stat;
    }

    public void setOrd_stat(int ord_stat) {
        this.ord_stat = ord_stat;
    }

    public String getB_style() {
        return b_style;
    }

    public void setB_style(String b_style) {
        this.b_style = b_style;
    }

    public List getSeasonList() {
        return seasonList;
    }

    public void setSeasonList(List seasonList) {
        this.seasonList = seasonList;
    }

    public String getQuota_cat() {
        return quota_cat;
    }

    public void setQuota_cat(String quota_cat) {
        this.quota_cat = quota_cat;
    }

    public String getGarment_desc() {
        return garment_desc;
    }

    public void setGarment_desc(String garment_desc) {
        this.garment_desc = garment_desc;
    }

    public String getInt_ord() {
        return int_ord;
    }

    public void setInt_ord(String int_ord) {
        this.int_ord = int_ord;
    }

    public String getQuota_seg() {
        return quota_seg;
    }

    public void setQuota_seg(String quota_seg) {
        this.quota_seg = quota_seg;
    }

    public Date getOrder_date() {
        return order_date;
    }

    public void setOrder_date(Date order_date) {
        this.order_date = order_date;
    }

    public Season getSeasonbean() {
        return seasonbean;
    }

    public void setSeasonbean(Season seasonbean) {
        this.seasonbean = seasonbean;
    }

    public int getSerial() {
        return serial;
    }

    public void setSerial(int serial) {
        this.serial = serial;
    }

    public String getStyle_no() {
        return style_no;
    }

    public void setStyle_no(String style_no) {
        this.style_no = style_no;
    }

    public int getOrder_qty() {
        return order_qty;
    }

    public void setOrder_qty(int order_qty) {
        this.order_qty = order_qty;
    }

    public Date getDelv_date() {
        return delv_date;
    }

    public void setDelv_date(Date delv_date) {
        this.delv_date = delv_date;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getWov_hos() {
        return wov_hos;
    }

    public void setWov_hos(String wov_hos) {
        this.wov_hos = wov_hos;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getEmb_fl() {
        return emb_fl;
    }

    public void setEmb_fl(String emb_fl) {
        this.emb_fl = emb_fl;
    }

    public String getMain_fab() {
        return main_fab;
    }

    public void setMain_fab(String main_fab) {
        this.main_fab = main_fab;
    }

    public String getPrint() {
        return print;
    }

    public void setPrint(String print) {
        this.print = print;
    }

    public String getFab_con() {
        return fab_con;
    }

    public void setFab_con(String fab_con) {
        this.fab_con = fab_con;
    }

    public int getComp_code() {
        return comp_code;
    }

    public void setComp_code(int comp_code) {
        this.comp_code = comp_code;
    }

    public String getDyed() {
        return dyed;
    }

    public void setDyed(String dyed) {
        this.dyed = dyed;
    }

    public String getOrder_no() {
        return order_no;
    }

    public void setOrder_no(String order_no) {
        this.order_no = order_no;
    }

    public int getColour() {
        return colour;
    }

    public void setColour(int colour) {
        this.colour = colour;
    }

    public int getColour_code() {
        return colour_code;
    }

    public void setColour_code(int colour_code) {
        this.colour_code = colour_code;
    }

    public JSONArray getChoices() {
        return choices;
    }

    public void setChoices(JSONArray choices) {
        this.choices = choices;
    }

    public String getP_type() {
        return p_type;
    }

    public void setP_type(String p_type) {
        this.p_type = p_type;
    }

    public String getColour_way() {
        return colour_way;
    }

    public void setColour_way(String colour_way) {
        this.colour_way = colour_way;
    }

  
    public String getAgent_comm() {
        return agent_comm;
    }

    public void setAgent_comm(String agent_comm) {
        this.agent_comm = agent_comm;
    }

    public String getQuota_grp() {
        return quota_grp;
    }

    public void setQuota_grp(String quota_grp) {
        this.quota_grp = quota_grp;
    }

    public String getAssort() {
        return assort;
    }

    public void setAssort(String assort) {
        this.assort = assort;
    }

    public int getComm_perc() {
        return comm_perc;
    }

    public void setComm_perc(int comm_perc) {
        this.comm_perc = comm_perc;
    }

    public JSONObject getData() {
        return data;
    }

    public void setData(JSONObject data) {
        this.data = data;
    }

    public JSONArray getSizeprice() {
        return sizeprice;
    }

    public void setSizeprice(JSONArray sizeprice) {
        this.sizeprice = sizeprice;
    }

    public int getFab_rate() {
        return fab_rate;
    }

    public void setFab_rate(int fab_rate) {
        this.fab_rate = fab_rate;
    }

    public int getIntfab_rate() {
        return intfab_rate;
    }

    public void setIntfab_rate(int intfab_rate) {
        this.intfab_rate = intfab_rate;
    }

    public int getHd_rate() {
        return hd_rate;
    }

    public void setHd_rate(int hd_rate) {
        this.hd_rate = hd_rate;
    }

    public int getMc_rate() {
        return mc_rate;
    }

    public void setMc_rate(int mc_rate) {
        this.mc_rate = mc_rate;
    }

    public int getAr_rate() {
        return ar_rate;
    }

    public void setAr_rate(int ar_rate) {
        this.ar_rate = ar_rate;
    }

  

    public int getOthers() {
        return others;
    }

    public void setOthers(int others) {
        this.others = others;
    }

    public int getOth1() {
        return oth1;
    }

    public void setOth1(int oth1) {
        this.oth1 = oth1;
    }

    public int getOth2() {
        return oth2;
    }

    public void setOth2(int oth2) {
        this.oth2 = oth2;
    }

    public int getOth3() {
        return oth3;
    }

    public void setOth3(int oth3) {
        this.oth3 = oth3;
    }

    public int getOth4() {
        return oth4;
    }

    public void setOth4(int oth4) {
        this.oth4 = oth4;
    }

    public int getOth5() {
        return oth5;
    }

    public void setOth5(int oth5) {
        this.oth5 = oth5;
    }

    public int getOth6() {
        return oth6;
    }

    public void setOth6(int oth6) {
        this.oth6 = oth6;
    }

    public int getOth7() {
        return oth7;
    }

    public void setOth7(int oth7) {
        this.oth7 = oth7;
    }

    public int getOth8() {
        return oth8;
    }

    public void setOth8(int oth8) {
        this.oth8 = oth8;
    }

    public int getOth9() {
        return oth9;
    }

    public void setOth9(int oth9) {
        this.oth9 = oth9;
    }

  

    public String getOth_desc() {
        return oth_desc;
    }

    public void setOth_desc(String oth_desc) {
        this.oth_desc = oth_desc;
    }

    public String getOth1_desc() {
        return oth1_desc;
    }

    public void setOth1_desc(String oth1_desc) {
        this.oth1_desc = oth1_desc;
    }

    public String getOth2_desc() {
        return oth2_desc;
    }

    public void setOth2_desc(String oth2_desc) {
        this.oth2_desc = oth2_desc;
    }

    public String getOth3_desc() {
        return oth3_desc;
    }

    public void setOth3_desc(String oth3_desc) {
        this.oth3_desc = oth3_desc;
    }

    public String getOth4_desc() {
        return oth4_desc;
    }

    public void setOth4_desc(String oth4_desc) {
        this.oth4_desc = oth4_desc;
    }

    public String getOth5_desc() {
        return oth5_desc;
    }

    public void setOth5_desc(String oth5_desc) {
        this.oth5_desc = oth5_desc;
    }

    public String getOth6_desc() {
        return oth6_desc;
    }

    public void setOth6_desc(String oth6_desc) {
        this.oth6_desc = oth6_desc;
    }

    public String getOth7_desc() {
        return oth7_desc;
    }

    public void setOth7_desc(String oth7_desc) {
        this.oth7_desc = oth7_desc;
    }

    public String getOth8_desc() {
        return oth8_desc;
    }

    public void setOth8_desc(String oth8_desc) {
        this.oth8_desc = oth8_desc;
    }

    public String getOth9_desc() {
        return oth9_desc;
    }

    public void setOth9_desc(String oth9_desc) {
        this.oth9_desc = oth9_desc;
    }

   

    public int getOth1_seq() {
        return oth1_seq;
    }

    public void setOth1_seq(int oth1_seq) {
        this.oth1_seq = oth1_seq;
    }

    public int getOth2_seq() {
        return oth2_seq;
    }

    public void setOth2_seq(int oth2_seq) {
        this.oth2_seq = oth2_seq;
    }

    public int getOth3_seq() {
        return oth3_seq;
    }

    public void setOth3_seq(int oth3_seq) {
        this.oth3_seq = oth3_seq;
    }

    public int getOth4_seq() {
        return oth4_seq;
    }

    public void setOth4_seq(int oth4_seq) {
        this.oth4_seq = oth4_seq;
    }

    public int getOth5_seq() {
        return oth5_seq;
    }

    public void setOth5_seq(int oth5_seq) {
        this.oth5_seq = oth5_seq;
    }

    public int getOth6_seq() {
        return oth6_seq;
    }

    public void setOth6_seq(int oth6_seq) {
        this.oth6_seq = oth6_seq;
    }

    public int getOTH7_SEQ() {
        return OTH7_SEQ;
    }

    public void setOTH7_SEQ(int OTH7_SEQ) {
        this.OTH7_SEQ = OTH7_SEQ;
    }

    public int getOTH8_SEQ() {
        return OTH8_SEQ;
    }

    public void setOTH8_SEQ(int OTH8_SEQ) {
        this.OTH8_SEQ = OTH8_SEQ;
    }

    public int getOTH9_SEQ() {
        return OTH9_SEQ;
    }

    public void setOTH9_SEQ(int OTH9_SEQ) {
        this.OTH9_SEQ = OTH9_SEQ;
    }

    public int getOTH10_SEQ() {
        return OTH10_SEQ;
    }

    public void setOTH10_SEQ(int OTH10_SEQ) {
        this.OTH10_SEQ = OTH10_SEQ;
    }

    

    public String getAllcontrol() {
        return allcontrol;
    }

    public void setAllcontrol(String allcontrol) {
        this.allcontrol = allcontrol;
    }

    @Override
    public String toString() {
        return "Order{" + "seas_code=" + seas_code + ", buyer_code=" + buyer_code + ", ord_stat=" + ord_stat + ", b_style=" + b_style + ", seasonList=" + seasonList + ", quota_seg=" + quota_seg + ", quota_cat=" + quota_cat + ", order_date=" + order_date + ", garment_desc=" + garment_desc + ", int_ord=" + int_ord + ", seasonbean=" + seasonbean + ", serial=" + serial + ", style_no=" + style_no + ", order_qty=" + order_qty + ", delv_date=" + delv_date + ", price=" + price + ", wov_hos=" + wov_hos + ", order_no=" + order_no + ", currency=" + currency + ", emb_fl=" + emb_fl + ", main_fab=" + main_fab + ", print=" + print + ", fab_con=" + fab_con + ", comp_code=" + comp_code + ", dyed=" + dyed + ", colour=" + colour + ", colour_code=" + colour_code + ", choices=" + choices + ", p_type=" + p_type + ", colour_way=" + colour_way + ", agent_comm=" + agent_comm + ", quota_grp=" + quota_grp + ", assort=" + assort + ", comm_perc=" + comm_perc + ", data=" + data + ", sizeprice=" + sizeprice + ", fab_rate=" + fab_rate + ", intfab_rate=" + intfab_rate + ", hd_rate=" + hd_rate + ", mc_rate=" + mc_rate + ", ar_rate=" + ar_rate + ", others=" + others + ", oth1=" + oth1 + ", oth2=" + oth2 + ", oth3=" + oth3 + ", oth4=" + oth4 + ", oth5=" + oth5 + ", oth6=" + oth6 + ", oth7=" + oth7 + ", oth8=" + oth8 + ", oth9=" + oth9 + ", oth_desc=" + oth_desc + ", oth1_desc=" + oth1_desc + ", oth2_desc=" + oth2_desc + ", oth3_desc=" + oth3_desc + ", oth4_desc=" + oth4_desc + ", oth5_desc=" + oth5_desc + ", oth6_desc=" + oth6_desc + ", oth7_desc=" + oth7_desc + ", oth8_desc=" + oth8_desc + ", oth9_desc=" + oth9_desc + ", oth1_seq=" + oth1_seq + ", oth2_seq=" + oth2_seq + ", oth3_seq=" + oth3_seq + ", oth4_seq=" + oth4_seq + ", oth5_seq=" + oth5_seq + ", oth6_seq=" + oth6_seq + ", OTH7_SEQ=" + OTH7_SEQ + ", OTH8_SEQ=" + OTH8_SEQ + ", OTH9_SEQ=" + OTH9_SEQ + ", OTH10_SEQ=" + OTH10_SEQ + ", allcontrol=" + allcontrol + '}';
    }

   

}
