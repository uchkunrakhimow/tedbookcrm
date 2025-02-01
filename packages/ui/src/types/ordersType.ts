type OrderStatus =
  | 'Pending (In the logist)'
  | 'Pending (In the courier)'
  | 'Delivered'
  | 'Canceled'
  | string;

type ProductsType = {
  productId: {
    _id: string;
    title: string;
    price: number;
  };
  discount: number;
  discountPrice: number;
  _id: string;
};
export interface OrdersType {
  _id: string;
  operatorId: {
    _id: string;
    name: string;
    username: string;
    shift: number | null;
  };
  courierId: {
    _id: string;
    name: string;
    username: string;
    shift: number | null;
  };
  logisticianId: {
    _id: string;
    name: string;
    username: string;
    shift: number | null;
  };
  fullName: string;
  phoneNumber: string;
  phoneNumber2: string;
  status: OrderStatus;
  productIds: ProductsType[];
  region: string;
  district: string;
  city: string;
  address: string;
  is_archive: boolean;
  messages: CommentMessagesType[];
  payments: {
    method: string;
    amount: number;
    _id: string;
  }[];
  createdAt: string;
  updatedAt: string;
  editHistory: {
    editorId: {
      _id: string;
      name: string;
      username: string;
    };
    editTime: string;
    editDuration: number;
    _id: string;
  }[];
}

export interface CreateOrdersBodyType {
  operatorId: string;
  fullName: string;
  phoneNumber: string;
  phoneNumber2: string | null;
  productIds: {
    productId: string;
    discount: number | null;
    discountPrice: number | null;
  }[];
  region: string | null;
  district: string | null;
  city: string | null;
  logisticianId: string;
  address: string | null;
  messages: {
    commenterRole: string;
    commentText: string;
  }[];
  payments: {
    method: string;
    amount: number;
  }[];
}

export type GetAllOrdersResponseType = {
  data: {
    total: number;
    page: number;
    totalPages: number;
    orders: OrdersType[];
  };
  message: string;
};

export type CommentMessagesType = {
  commenterRole: string;
  commentText: string;
  _id: string;
  createdAt: string;
};
