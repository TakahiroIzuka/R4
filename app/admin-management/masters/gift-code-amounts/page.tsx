import { createClient } from '@/lib/supabase/server'
import GiftCodeAmountManager from '@/components/management/GiftCodeAmountManager'

export default async function GiftCodeAmountsPage() {
  const supabase = await createClient()

  // Fetch gift code amounts data
  const { data: giftCodeAmounts } = await supabase
    .from('gift_code_amounts')
    .select('*')
    .order('amount', { ascending: true })

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900 mb-6">マスタ管理 - ギフトコード額</h1>
      <GiftCodeAmountManager giftCodeAmounts={giftCodeAmounts || []} />
    </div>
  )
}
