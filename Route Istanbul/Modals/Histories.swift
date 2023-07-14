//
//  Histories.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 20.06.2023.
//

import Foundation

class Histories {
    
var tarih_id:String?
var tarih_ad:String?
var tarih_resim:String?
var kategori_ad:String?
var tarih_kisa:String?
var tarih_uzun:String?
var tarih_enlem:Double?
var tarih_boylam:Double?
    
    init() {
    }
    
    init(tarih_id:String,tarih_ad:String,tarih_resim:String,kategori_ad:String,tarih_kisa:String,tarih_uzun:String,tarih_enlem:Double,tarih_boylam:Double) {
        self.tarih_id = tarih_id
        self.tarih_ad = tarih_ad
        self.tarih_resim = tarih_resim
        self.kategori_ad = kategori_ad
        self.tarih_kisa = tarih_kisa
        self.tarih_uzun = tarih_uzun
        self.tarih_enlem = tarih_enlem
        self.tarih_boylam = tarih_boylam
     
    }
}
