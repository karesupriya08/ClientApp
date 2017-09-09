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
public class Colour {
    private int colour_code;
    private String colour_desc;
    private String flag;

    public int getColour_code() {
        return colour_code;
    }

    public void setColour_code(int colour_code) {
        this.colour_code = colour_code;
    }

    public String getColour_desc() {
        return colour_desc;
    }

    public void setColour_desc(String colour_desc) {
        this.colour_desc = colour_desc;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    @Override
    public String toString() {
        return "Colour{" + "colour_code=" + colour_code + ", colour_desc=" + colour_desc + ", flag=" + flag + '}';
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 47 * hash + this.colour_code;
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
        final Colour other = (Colour) obj;
        if (this.colour_code != other.colour_code) {
            return false;
        }
        return true;
    }
    
    
}
