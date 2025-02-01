export interface ProductsType {
  total: number;
  page: number;
  totalPages: number;
  products: {
    _id: string;
    title: string;
    comment?: string;
    price: number;
    createdAt: string;
    updatedAt: string;
  }[];
}

export interface CreateProductsBodyType {
  title: string;
  comment?: string;
  price: number;
}

export interface UpdateProductsBodyType {
  title: string;
  comment?: string;
  price: number;
}

export type GetAllProductsResponseType = ProductsType;
