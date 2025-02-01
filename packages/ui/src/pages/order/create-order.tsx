import district from '@/api/districts.json';
import city from '@/api/villages.json';
import { Button } from '@/components/custom/button';
import { Combobox } from '@/components/custom/combobox';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { MultiSelect } from '@/components/ui/multi-select';
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { selectRegion } from '@/constants/regions';
import { useCreateOrder } from '@/hooks/useOrderQuery';
import { useProductQuery } from '@/hooks/useProductQuery';
import { useLogisticianUsers } from '@/hooks/useUsersQuery';
import { cn } from '@/lib/utils';
import { selectUser } from '@/redux/selectors/auth';
import { useAppSelector } from '@/redux/store';
import { zodResolver } from '@hookform/resolvers/zod';
import { IconArrowLeftDashed } from '@tabler/icons-react';
import { isArray } from 'lodash';
import { Minus, Plus } from 'lucide-react';
import { HTMLAttributes, useEffect } from 'react';
import { useFieldArray, useForm } from 'react-hook-form';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { z } from 'zod';

interface OrderProps extends HTMLAttributes<HTMLDivElement> {}

const productIdsSchema = z.array(
  z
    .object({
      productId: z.string(),
      discount: z.number().nullable(),
      discountPrice: z.number().nullable(),
    })
    .required(),
);

const formSchema = z.object({
  operatorId: z.string(),
  fullName: z.string().min(3, { message: '' }),
  phoneNumber: z.string().min(9, { message: '' }),
  phoneNumber2: z.string().min(9, { message: '' }).or(z.null()).default(null),
  productIds: productIdsSchema,
  region: z.string().min(3, { message: '' }),
  logisticianId: z.string().min(3, { message: '' }),
  address: z.string().or(z.null()).default(null),
  messages: z
    .array(
      z.object({
        commenterRole: z.string().min(3, { message: '' }),
        commentText: z.string().min(3, { message: '' }),
      }),
    )
    .default([]),
  district: z.string(),
  city: z.string(),
  payments: z.array(z.string()).default([]),
  amount: z.number().default(0),
});

const discounts = [10, 20, 30, 40, 50];

export default function CreateOrder({ className, ...props }: OrderProps) {
  const navigate = useNavigate();
  const { t } = useTranslation();
  const user = useAppSelector(selectUser);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      operatorId: user?.id,
      fullName: '',
      phoneNumber: '',
      phoneNumber2: null,
      productIds: [
        {
          productId: '',
          discount: null,
          discountPrice: null,
        },
      ],
      logisticianId: '',
      address: null,
      messages: [],
      region: '',
      district: '',
      city: '',
      payments: [],
      amount: 0,
    },
  });

  const {
    remove: removeProduct,
    append: appendProduct,
    fields: productFields,
  } = useFieldArray({
    control: form.control,
    name: 'productIds',
  });

  const { resData } = useProductQuery();
  const { data: LogisticianData } = useLogisticianUsers();
  const { mutate, isPending } = useCreateOrder();

  const products = form.watch('productIds');

  useEffect(() => {
    const total = products.reduce((acc, product) => {
      const price =
        resData.find((item) => item._id === product.productId)?.price || 0;
      const discount = product.discount;
      if (!discount) return Number(acc) + Number(price);
      const discountPrice = price - (price * discount) / 100;

      return acc + discountPrice;
    }, 0);

    form.setValue('amount', total);
  }, [JSON.stringify(products), resData]);

  useEffect(() => {
    products.forEach((product, index) => {
      const price =
        resData.find((item) => item._id === product.productId)?.price || 0;
      const discount = product.discount;
      if (!discount) {
        form.setValue(`productIds.${index}.discountPrice`, null);
        return;
      }
      const discountPrice = price - (price * discount) / 100;

      form.setValue(`productIds.${index}.discountPrice`, discountPrice);
    });
  }, [JSON.stringify(products), resData]);

  function onSubmit() {
    const { payments, amount, ...oldForm } = form.getValues();
    const newPayments = payments.map((payment) => ({
      method: payment,
      amount,
    }));

    const newForm = {
      ...oldForm,
      payments: newPayments,
    };

    mutate(newForm, {
      onSuccess: () => {
        navigate(-1);
      },
    });
  }

  const paymentTranslations: Record<string, string> = {
    cash: 'Naqd pul',
    card: 'Karta',
    'payment-systems': "To'lov tizimlari - (Click, payme, uzum)",
  };

  return (
    <div className={cn('grid gap-6', className)} {...props}>
      <div className="grid mb-3">
        <div className="grid">
          <h1 className="text-2xl font-semibold tracking-tight">
            {t('pages.orders.create.title')}
          </h1>
          <div
            data-orientation="horizontal"
            role="none"
            className="my-4 h-[1px] w-full shrink-0 bg-border lg:my-6"
          ></div>
        </div>
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)}>
            <div className="grid w-full gap-3 md:w-full lg:w-[70%] xl:w-[50%] 2xl:w-[35%]">
              <FormField
                control={form.control}
                name="logisticianId"
                render={({ field }) => (
                  <FormItem>
                    <div className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                      <FormLabel>
                        {t('pages.orders.create.fields.selLogistician')}{' '}
                        <span className="text-red-600">*</span>
                      </FormLabel>
                      <Select onValueChange={field.onChange}>
                        <SelectTrigger>
                          <SelectValue
                            placeholder={t(
                              'pages.orders.create.fields.selLogistician',
                            )}
                            defaultValue={field.value || ''}
                          />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectGroup>
                            <SelectLabel>
                              {t('pages.orders.create.fields.selLogistician')}
                            </SelectLabel>
                            {isArray(LogisticianData?.users) &&
                              LogisticianData?.users.map((option, idx) => (
                                <SelectItem key={idx} value={option._id}>
                                  {option.name}
                                </SelectItem>
                              ))}
                          </SelectGroup>
                        </SelectContent>
                      </Select>
                    </div>
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="fullName"
                render={({ field }) => (
                  <FormItem className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                    <FormLabel>
                      {t('pages.orders.create.fields.fullName')}{' '}
                      <span className="text-red-600">*</span>
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder={t('pages.orders.create.fields.fullName')}
                        {...field}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="phoneNumber"
                render={({ field }) => (
                  <FormItem className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                    <FormLabel>
                      {t('pages.orders.create.fields.phoneNumber')}{' '}
                      <span className="text-red-600">*</span>
                    </FormLabel>
                    <FormControl>
                      <Input placeholder={t('+998')} {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="phoneNumber2"
                render={({ field }) => (
                  <FormItem className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                    <FormLabel>
                      {t('pages.orders.create.fields.phoneNumber')} 2
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder={t('+998')}
                        {...field}
                        value={field.value ?? ''}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <div className="grid gap-5 space-y-1 grid-cols-1_2">
                <FormLabel>
                  {t('pages.orders.create.fields.selProducts')}
                  <span className="text-red-600">*</span>
                </FormLabel>
                <div className="flex flex-col flex-1 gap-2">
                  <div className="relative flex flex-col gap-2">
                    {productFields.map((field, index) => (
                      <div
                        key={field.id}
                        className="flex flex-col flex-1 gap-2"
                      >
                        <FormField
                          control={form.control}
                          name={`productIds.${index}.productId`}
                          render={({ field }) => (
                            <FormItem>
                              <FormControl>
                                <Select onValueChange={field.onChange}>
                                  <SelectTrigger>
                                    <SelectValue
                                      placeholder={t(
                                        'pages.orders.table.columns.products',
                                      )}
                                      defaultValue={field.value || ''}
                                    />
                                  </SelectTrigger>
                                  <SelectContent>
                                    <SelectGroup>
                                      <SelectLabel>
                                        {t(
                                          'pages.orders.table.columns.products',
                                        )}
                                      </SelectLabel>
                                      {resData?.map((option, idx) => (
                                        <SelectItem
                                          key={idx}
                                          value={option._id}
                                        >
                                          {option.title}
                                        </SelectItem>
                                      ))}
                                    </SelectGroup>
                                  </SelectContent>
                                </Select>
                              </FormControl>
                              <FormMessage />
                            </FormItem>
                          )}
                        />
                        <FormField
                          control={form.control}
                          name={`productIds.${index}.discount`}
                          render={({ field }) => (
                            <FormItem>
                              <FormControl>
                                <Select
                                  onValueChange={(value) =>
                                    field.onChange(Number(value))
                                  }
                                >
                                  <SelectTrigger>
                                    <SelectValue
                                      placeholder={t(
                                        'pages.orders.create.fields.discount',
                                      )}
                                      defaultValue={field.value || ''}
                                    />
                                  </SelectTrigger>
                                  <SelectContent>
                                    <SelectGroup>
                                      <SelectLabel>
                                        {t(
                                          'pages.orders.create.fields.discount',
                                        )}
                                      </SelectLabel>
                                      {discounts.map((discount, idx) => (
                                        <SelectItem
                                          key={idx}
                                          value={discount.toString()}
                                        >
                                          {discount}%
                                        </SelectItem>
                                      ))}
                                    </SelectGroup>
                                  </SelectContent>
                                </Select>
                              </FormControl>
                              <FormMessage />
                            </FormItem>
                          )}
                        />
                        <div className="flex items-center justify-between gap-2">
                          <FormField
                            control={form.control}
                            name={`productIds.${index}.discountPrice`}
                            render={({ field }) => (
                              <FormItem className="flex-1">
                                <FormControl>
                                  <Input
                                    placeholder={t(
                                      'pages.orders.create.fields.discountPrice',
                                    )}
                                    disabled
                                    {...field}
                                    value={field.value ?? ''}
                                  />
                                </FormControl>
                                <FormMessage />
                              </FormItem>
                            )}
                          />
                          <Button
                            type="button"
                            variant="outline"
                            onClick={() => removeProduct(index)}
                          >
                            <Minus size={18} className="me-2" />
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() =>
                      appendProduct({
                        productId: '',
                        discount: null,
                        discountPrice: null,
                      })
                    }
                  >
                    <Plus size={18} className="me-2" />
                  </Button>
                </div>
              </div>
              <FormField
                control={form.control}
                name="region"
                render={({ field }) => (
                  <FormItem>
                    <div className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                      <FormLabel>
                        {t('pages.orders.create.fields.regions')}{' '}
                        <span className="text-red-600">*</span>
                      </FormLabel>
                      <FormControl>
                        <Combobox
                          value={field.value}
                          onChange={field.onChange}
                          options={selectRegion.map((item) => ({
                            label: item.label,
                            value: item.label,
                          }))}
                          placeholder={t('pages.orders.create.fields.regions')}
                          placeholderInput={t(
                            'pages.orders.create.fields.regions',
                          )}
                          emptyText={t('pages.orders.create.fields.regions')}
                        />
                      </FormControl>
                    </div>
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="district"
                render={({ field }) => (
                  <FormItem>
                    <div className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                      <FormLabel>Tumanlar</FormLabel>
                      <FormControl>
                        <Combobox
                          value={field.value}
                          onChange={field.onChange}
                          options={district.map((item) => ({
                            label: item.name_uz,
                            value: item.name_uz,
                          }))}
                          placeholder="Tumanlar"
                          placeholderInput="Tumanlar"
                          emptyText="Tumanlar"
                        />
                      </FormControl>
                    </div>
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="city"
                render={({ field }) => (
                  <FormItem>
                    <div className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                      <FormLabel>Shaharlar yoki qishloqlar</FormLabel>
                      <FormControl>
                        <Combobox
                          value={field.value}
                          onChange={field.onChange}
                          options={city.map((item) => ({
                            label: item.name_uz,
                            value: item.name_uz,
                          }))}
                          placeholder="Shaharlar yoki qishloqlar"
                          placeholderInput="Shaharlar yoki qishloqlar"
                          emptyText="Shaharlar yoki qishloqlar"
                        />
                      </FormControl>
                    </div>
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="address"
                render={({ field }) => (
                  <FormItem className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                    <FormLabel>
                      {t('pages.orders.create.fields.address')}
                    </FormLabel>
                    <FormControl>
                      <Input
                        placeholder={t('pages.orders.create.fields.address')}
                        {...field}
                        value={field.value ?? ''}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="payments"
                render={({ field }) => (
                  <FormItem className="grid items-center gap-5 space-y-1 grid-cols-1_2">
                    <FormLabel>To'lov turi</FormLabel>
                    <FormControl>
                      <MultiSelect
                        options={
                          Object.entries(paymentTranslations).map(
                            ([key, value]) => ({
                              label: value,
                              value: key,
                            }),
                          ) ?? []
                        }
                        onValueChange={(value) => field.onChange(value)}
                        placeholder="To'lov turini tanlang"
                        variant="inverted"
                        animation={2}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="amount"
                render={({ field }) => (
                  <FormItem className="grid items-center gap-5 mt-2 space-y-1 grid-cols-1_2">
                    <FormLabel>To'lov miqdori</FormLabel>
                    <FormControl>
                      <Input disabled placeholder="To'lov miqdori" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
            </div>
            <div className="flex justify-end gap-3 mt-4">
              <Button
                type="button"
                variant="outline"
                onClick={() => {
                  form.reset();
                  navigate(-1);
                }}
              >
                <IconArrowLeftDashed size={18} className="me-2" />{' '}
                {t('pages.orders.create.buttons.back')}
              </Button>
              <Button loading={isPending}>
                {t('pages.orders.create.buttons.save')}
              </Button>
            </div>
          </form>
        </Form>
      </div>
    </div>
  );
}
