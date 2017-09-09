/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Model;

/**
 *
 * @author Supriya Kare
 */
public class Season {
    private String  seas_code;
    private String seas_desc;

    public Season() {
    }

    public Season(String seas_code, String seas_desc) {
        this.seas_code = seas_code;
        this.seas_desc = seas_desc;
    }

    public String getSeas_code() {
        return seas_code;
    }

    public void setSeas_code(String seas_code) {
        this.seas_code = seas_code;
    }

    public String getSeas_desc() {
        return seas_desc;
    }

    public void setSeas_desc(String seas_desc) {
        this.seas_desc = seas_desc;
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 23 * hash + (this.seas_code != null ? this.seas_code.hashCode() : 0);
        hash = 23 * hash + (this.seas_desc != null ? this.seas_desc.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Season other = (Season) obj;
        return true;
    }
   
}
