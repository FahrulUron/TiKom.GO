<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderMenuDetail extends Model
{
    /** @use HasFactory<\Database\Factories\OrderMenuDetailFactory> */
    use HasFactory;
    protected $fillable = [
        'order_menu_id',
        'menu_id',
        'jumlah',
        'harga',
        'total_subtotal',
    ];

    public function menu()
    {
        return $this->belongsTo(Menu::class, 'menu_id', 'id');
    }
}
