<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Menu;
use App\Models\OrderMenu;
use App\Models\OrderMenuDetail;
use Illuminate\Database\Eloquent\Casts\Json;
use Illuminate\Support\Facades\Validator;

class OrderMenuController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $model = OrderMenu::where('status', 'DIPESAN')->get();
        return response()->json([
            'status' => true,
            'message' => 'Data berhasil ditemukan',
            'data' => $model,
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'meja_no' => 'required',
            'nama_pembeli' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validasi Error',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $request->all();
        $data['status'] = "BELUM DIPESAN";

        $menu = OrderMenu::create($data);
        return response()->json([
            'status' => true,
            'message' => 'Order menu berhasil dibuat',
            'data' => $menu,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $model = OrderMenu::find($id);

        if ($model) {
            $modelDetail = OrderMenuDetail::where('order_menu_id', $id)->get();

            foreach ($modelDetail as $detail) {
                $detail->delete();
            }

            $model->delete();

            return response()->json([
                'status' => true,
                'message' => 'Data berhasil dihapus',
            ], 200);
        } else {
            return response()->json([
                'status' => false,
                'message' => 'Data tidak ditemukan',
            ], 404);
        }
    }

    public function pesan(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_menu_id' => 'required',
            'order_menu_detail' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validasi Error',
                'errors' => $validator->errors(),
            ], 422);
        }

        // ambil orderan detail dulu
        $data = $request->all();

        $totalHarga = 0;

        foreach ($data['order_menu_detail'] as $key => $value) {
            $orderMenuDetail = OrderMenuDetail::find($value['id']);
            $menu = Menu::find($orderMenuDetail->menu_id);
            $total = $menu->harga * $value['jumlah'];

            $orderMenuDetail->jumlah = $value['jumlah'];
            $orderMenuDetail->total_subtotal = $total;
            $orderMenuDetail->save();

            $totalHarga += $total;
        }

        //set total harga dan ubah status menjadi 
        $orderMenu = OrderMenu::find($data['order_menu_id']);
        $orderMenu->total_harga = $totalHarga;
        $orderMenu->status = "DIPESAN";
        $orderMenu->save();

        return response()->json([
            'status' => true,
            'message' => 'Data berhasil diupdate',
            'data' => $orderMenu,
        ], 200);
    }

    public function selesaikanPesanan(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_menu_id' => 'required',
            'order_menu_detail' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validasi Error',
                'errors' => $validator->errors(),
            ], 422);
        }

        // ambil orderan detail dulu
        $data = $request->all();

        $totalHarga = 0;

        foreach ($data['order_menu_detail'] as $key => $value) {
            $orderMenuDetail = OrderMenuDetail::find($value['id']);
            $menu = Menu::find($orderMenuDetail->menu_id);
            $total = $menu->harga * $value['jumlah'];

            $orderMenuDetail->jumlah = $value['jumlah'];
            $orderMenuDetail->total_subtotal = $total;
            $orderMenuDetail->save();

            $totalHarga += $total;
        }

        //set total harga dan ubah status menjadi 
        $orderMenu = OrderMenu::find($data['order_menu_id']);
        $orderMenu->total_harga = $totalHarga;
        $orderMenu->status = "SELESAI";
        $orderMenu->save();

        return response()->json([
            'status' => true,
            'message' => 'Data berhasil diupdate',
            'data' => $orderMenu,
        ], 200);
    }
}
