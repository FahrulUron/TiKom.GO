<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\OrderMenuDetail;
use Illuminate\Support\Facades\Validator;

class OrderMenuDetailController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_menu_id' => 'required|integer',
            'menu_id' => 'required|integer',
            'jumlah' => 'required',
            'harga' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validasi Error',
                'errors' => $validator->errors(),
            ], 422);
        }

        $model = OrderMenuDetail::where(['order_menu_id' => $request->input('order_menu_id'), 'menu_id' => $request->input('menu_id')])->get();


        if ($model->isEmpty()) {
            $data = $request->all();

            // Hitung total dari inputan jumlah dan harga
            $data['total_subtotal'] = $data['jumlah'] * $data['harga'];
            $model = OrderMenuDetail::create($data);
        }

        return response()->json([
            'status' => true,
            'message' => 'Data berhasil dimasukkan',
            'data' => $model,
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $data = OrderMenuDetail::where('order_menu_id', $id)->with('menu')->get();

        // Jika data tidak ditemukan, kembalikan respons error
        if ($data->isEmpty()) {
            return response()->json([
                'status' => false,
                'message' => 'Data tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'status' => true,
            'message' => 'Data berhasil ditemukan',
            'data' => $data,
        ], 200);
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
        $model = OrderMenuDetail::find($id);

        if ($model) {
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
}
