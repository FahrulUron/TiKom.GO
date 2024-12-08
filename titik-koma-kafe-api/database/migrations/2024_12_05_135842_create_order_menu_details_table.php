<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('order_menu_details', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_menu_id')->constrained(
                table: 'order_menus',
                indexName: 'order_menus_id'
            );
            $table->foreignId('menu_id')->constrained(
                table: 'menus',
                indexName: 'menu_menus_id'
            );
            $table->integer('jumlah');
            $table->decimal('harga', 15, 2);
            $table->decimal('total_subtotal', 15, 2);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('order_menu_details');
    }
};
