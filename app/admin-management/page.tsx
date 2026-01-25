import { createClient } from '@/lib/supabase/server'
import GiftCodesList from '@/components/management/GiftCodesList'

export default async function AdminManagementPage() {
  const supabase = await createClient()

  // Fetch gift code amounts and gift codes
  const [
    { data: giftCodeAmounts },
    { data: giftCodes }
  ] = await Promise.all([
    supabase
      .from('gift_code_amounts')
      .select('id, amount')
      .order('amount', { ascending: true }),
    supabase
      .from('gift_codes')
      .select(`
        *,
        gift_code_amounts (
          id,
          amount
        )
      `)
      .order('created_at', { ascending: false })
  ])

  return (
    <div>
      <h1 className="text-2xl font-semibold text-gray-900 mb-6">ダッシュボード</h1>
      <GiftCodesList
        giftCodes={giftCodes || []}
        giftCodeAmounts={giftCodeAmounts || []}
      />
    </div>
  )
}
