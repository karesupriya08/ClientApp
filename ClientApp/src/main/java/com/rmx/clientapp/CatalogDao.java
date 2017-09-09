/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp;

import com.rmx.clientapp.Model.Order;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author Supriya Kare
 */
public class CatalogDao {

    JdbcTemplate template;

    public void setTemplate(JdbcTemplate template) {
        this.template = template;
    }

    public JSONObject checkCatalogName(String cat_name) {
        String res = null;
        String sql = null;
        boolean flag = false;
        cat_name = cat_name.toUpperCase();
        final JSONObject js = new JSONObject();
        if (cat_name.length() > 0) {
            //  cat_name = cat_name.trim();
            System.out.println("cat_name==" + cat_name);
            sql = "select count(cat_name) from catalog where cat_name='" + cat_name + "' ";
            System.out.println("sql========" + sql);
            Integer rescat = template.queryForObject(sql, Integer.class);
            System.out.println("result======" + rescat);
            if (rescat > 0) {
                res = cat_name + " is already present";
                System.out.println("res====" + res);
                js.put("res", res);
                flag = true;
            } else {
                res = cat_name + " is not present";
                flag = false;
                js.put("res", res);
            }
            js.put("flag", flag);

        }
        return js;
    }
    
    public int addCatalog(String cat_name)
    {
        cat_name=cat_name.toUpperCase();
        String sql = "insert into catalog values('" + cat_name + "')";
        int r = template.update(sql);
        System.out.println("catalog update result====" + r);
        int res =  r;
         return res;
    }
    
    public List getCatalog()
    {
        return  template.query("select cat_name from catalog", new RowMapper<JSONObject>(){
      
            public JSONObject mapRow(ResultSet rs, int row) throws SQLException {
              
                JSONObject js = new JSONObject();
                js.put("cat_name", rs.getString(1));
         
                return js;
               }
        });
    }
   
}
