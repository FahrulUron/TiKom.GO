<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderMenu extends Model
{
    /** @use HasFactory<\Database\Factories\OrderMenuFactory> */
    use HasFactory;
    protected $fillable = [
        'no_transaksi',
        'meja_no',
        'nama_pembeli',
        'no_hp',
        'total_harga',
        'status',
    ];
}
