import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/custom/button';

export default function UnauthorisedError() {
  const navigate = useNavigate();
  return (
    <div className="h-svh">
      <div className="m-auto flex h-full w-full flex-col items-center justify-center gap-2">
        <h1 className="text-[7rem] font-bold leading-tight">401</h1>
        <span className="font-medium">
          Xavfsizligingiz uchun! Sessiyangiz vaqti tugagan ko'rinadi
        </span>
        <p className="text-center text-muted-foreground">
          Har bir foydalanuvchi uchun 1haftalik tizimdan foydalanish uchun
          ruxsat beriladi. <br />
          Iltimos, tizimga qaytadan kiring. 👇
        </p>
        <div className="mt-6 flex gap-4">
          <Button onClick={() => navigate('/auth/login')}>
            Tizimga kirish
          </Button>
        </div>
      </div>
    </div>
  );
}
